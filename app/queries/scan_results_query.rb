class ScanResultsQuery
  def initialize(scope = ScanResult)
    @relation = scope
  end

  def last_results
    @relation.joins(last_results_sql)
  end

  def last_nmap_results
    @relation.joins(last_nmap_results_sql)
  end

  def last_shodan_results
    @relation.joins(last_shodan_results_sql)
  end

  def not_registered_services
    @relation.where(not_registered_services_sql)
  end

  def nmap_vs_shodan#(organization_id)
    #@relation.find_by_sql(nmap_vs_shodan_sql)
    ActiveRecord::Base.connection.exec_query(nmap_vs_shodan_sql)
  end

  private

  def last_results_sql
    <<~SQL
      INNER JOIN (
        SELECT
          scan_results.ip,
          MAX(scan_results.job_start)
          AS max_time
        FROM scan_results
        GROUP BY scan_results.ip
      )m
      ON scan_results.ip = m.ip
      AND scan_results.job_start = m.max_time
    SQL
  end

  def last_nmap_results_sql
    <<~SQL
      INNER JOIN (
        SELECT
          scan_results.ip,
          MAX(scan_results.job_start)
          AS max_time
        FROM scan_results
        JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
        WHERE scan_jobs.scan_engine = 'nmap'
        GROUP BY scan_results.ip
      )m
      ON scan_results.ip = m.ip
      AND scan_results.job_start = m.max_time
    SQL
  end

  def last_shodan_results_sql
    <<~SQL
      INNER JOIN (
        SELECT
          scan_results.ip,
          MAX(scan_results.job_start)
          AS max_time
        FROM scan_results
        JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
        WHERE scan_jobs.scan_engine = 'shodan'
        GROUP BY scan_results.ip
      )m
      ON scan_results.ip = m.ip
      AND scan_results.job_start = m.max_time
    SQL
  end

  def nmap_vs_shodan_sql
    <<~SQL
      WITH nmap_results AS (
        SELECT scan_results.*,
        organizations.name AS organization_name,
        scan_jobs.scan_engine AS engine
        FROM scan_results
        LEFT JOIN (
          SELECT
            scan_results.ip,
            MAX(scan_results.job_start)
            AS max_time
          FROM scan_results
          JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
          WHERE scan_jobs.scan_engine = 'nmap'
          GROUP BY scan_results.ip
        )m
        ON scan_results.ip = m.ip
        AND scan_results.job_start = m.max_time
        LEFT JOIN hosts
        ON hosts.ip >>= scan_results.ip
        LEFT JOIN organizations
        ON organizations.id = hosts.organization_id
        LEFT JOIN scan_jobs
        ON scan_jobs.id = scan_results.scan_job_id
      ), shodan_results AS (
        SELECT scan_results.*,
        organizations.name AS organization_name,
        scan_jobs.scan_engine AS engine
        FROM scan_results
        INNER JOIN (
          SELECT
            scan_results.ip,
            MAX(scan_results.job_start)
            AS max_time
          FROM scan_results
          JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
          WHERE scan_jobs.scan_engine = 'shodan'
          GROUP BY scan_results.ip
        )m
        ON scan_results.ip = m.ip
        AND scan_results.job_start = m.max_time
        LEFT JOIN hosts
        ON hosts.ip >>= scan_results.ip
        LEFT JOIN organizations
        ON organizations.id = hosts.organization_id
        LEFT JOIN scan_jobs
        ON scan_jobs.id = scan_results.scan_job_id
      )
      SELECT DISTINCT
      nmap_results.organization_name AS nmap_organization_name,
      nmap_results.ip AS nmap_ip,
      nmap_results.port AS nmap_port,
      nmap_results.protocol AS nmap_protocol,
      shodan_results.organization_name AS shodan_organization_name,
      shodan_results.ip AS shodan_ip,
      shodan_results.port AS shodan_port,
      shodan_results.protocol AS shodan_protocol,
      nmap_results.engine || '/' || shodan_results.engine AS engines,
      shodan_results.vulns || '' || nmap_results.vulns AS vulns
      FROM nmap_results
      FULL JOIN shodan_results
      ON nmap_results.ip = shodan_results.ip
      AND nmap_results.port = shodan_results.port
      AND nmap_results.protocol = shodan_results.protocol
      AND nmap_results.state = shodan_results.state
    SQL
#      SELECT * FROM scan_results AS nmap_results
#      LEFT JOIN (
#        SELECT
#          scan_results.ip,
#          MAX(scan_results.job_start)
#          AS max_time
#        FROM scan_results
#        JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
#        WHERE scan_jobs.scan_engine = 'shodan'
#        GROUP BY scan_results.ip
#      )m
#      ON nmap_results.ip = m.ip
#      AND nmap_results.job_start = m.max_time
#      FULL JOIN (
#        SELECT * FROM scan_results AS pre_shodan_results
#        INNER JOIN (
#          SELECT
#            scan_results.ip,
#            MAX(scan_results.job_start)
#            AS max_time
#          FROM scan_results
#          JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
#          WHERE scan_jobs.scan_engine = 'shodan'
#          GROUP BY scan_results.ip
#        )m
#        ON scan_results.ip = m.ip
#        AND _results.job_start = m.max_time
#      )shodan_results
#      ON nmap_results.ip = shodan_results.ip
#      AND nmap_results.port = shodan_results.port
#      AND nmap_results.protocol = shodan_results.protocol
#    SQL
  end

  def not_registered_services_sql
    <<~SQL
      NOT EXISTS (
        SELECT null FROM host_services
        INNER JOIN hosts
        ON hosts.ip = scan_results.ip
        WHERE
        host_services.host_id = hosts.id AND
        host_services.port = scan_results.port AND
        host_services.protocol = scan_results.protocol
      )
   SQL
  end
end
