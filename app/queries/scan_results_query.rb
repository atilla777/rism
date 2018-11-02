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

  def nmap_vs_shodan(organization_id)
    ActiveRecord::Base.connection.exec_query(
      nmap_vs_shodan_sql,
      'postgresql',
      [[nil, organization_id]]
    )
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
        WHERE scan_results.scan_engine = 'nmap'
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
        WHERE scan_results.scan_engine = 'shodan'
        GROUP BY scan_results.ip
      )m
      ON scan_results.ip = m.ip
      AND scan_results.job_start = m.max_time
    SQL
  end

  def nmap_vs_shodan_sql
    <<~SQL
      WITH shodan_results AS (
        SELECT
        scan_results.ip,
        scan_results.port,
        scan_results.protocol,
        scan_results.state,
        scan_results.vulners,
        organizations.name AS organization_name,
        scan_results.scan_engine AS engine
        FROM scan_results
        INNER JOIN (
          SELECT
            scan_results.ip,
            MAX(scan_results.job_start)
            AS max_time
          FROM scan_results
          JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
          AND scan_results.scan_engine = 'shodan'
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
        WHERE scan_results.state = 5
        AND scan_results.scan_engine = 'shodan'
        AND ($1::int IS NULL OR organizations.id = $1)
      ), nmap_results AS (
        SELECT
        scan_results.ip,
        scan_results.port,
        scan_results.protocol,
        scan_results.state,
        scan_results.service,
        scan_results.product,
        scan_results.product_version,
        scan_results.product_extrainfo,
        scan_results.vulners,
        organizations.name AS organization_name,
        scan_results.scan_engine AS engine
        FROM scan_results
        LEFT JOIN (
          SELECT
            scan_results.ip,
            MAX(scan_results.job_start)
            AS max_time
          FROM scan_results
          JOIN scan_jobs ON scan_jobs.id = scan_results.scan_job_id
          AND scan_results.scan_engine = 'nmap'
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
        WHERE scan_results.state = 5
        AND scan_results.scan_engine = 'nmap'
        AND ($1::int IS NULL OR organizations.id = $1)
      )
      SELECT DISTINCT
      COALESCE(nmap_results.ip, shodan_results.ip) AS ip,
      COALESCE(nmap_results.port, shodan_results.port) AS port,
      COALESCE(nmap_results.protocol, shodan_results.protocol) AS protocol,
      COALESCE(nmap_results.organization_name, shodan_results.organization_name, '') AS organization_name,
      COALESCE(nmap_results.engine, '') || '/' || COALESCE(shodan_results.engine, '') AS engines,
      nmap_results.service AS service,
      nmap_results.product_version AS product_version,
      nmap_results.product_extrainfo AS product_extrainfo,
      shodan_results.vulners AS vulners
      FROM shodan_results
      FULL OUTER JOIN nmap_results
      ON shodan_results.ip = nmap_results.ip
      AND shodan_results.port = nmap_results.port
      AND shodan_results.protocol = nmap_results.protocol
      ORDER BY organization_name, ip, port, protocol
    SQL
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
