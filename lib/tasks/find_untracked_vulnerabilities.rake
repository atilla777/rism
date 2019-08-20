# frozen_string_literal: true

# Find vulnerabilities present in IN file that not in RISM base
# and write them to OUT file
#
# Run:
# rake rism:find_untracked_vulnerabilities['in.txt, out.txt']
#
# IN file format:
# CVE1
# CVE2
# ...
# CVEN

namespace :rism do
  desc 'Find vulnerabilities present (in file) that not in RISM base.'
  task :find_untracked_vulnerabilities, [:in_file, :out_file] => [:environment] do |_task, args|
    begin
      out_file = File.open(args[:out_file], 'w')

      File.open(args[:in_file], 'r').each do |vuln_codename|
        next if vuln_codename_in_base?(vuln_codename)
        log_missed_vuln_to_file(out_file, vuln_codename)
      end

      out_file.close
    rescue => e
      pp "Error - #{e}"
    end
  end
end

def log_missed_vuln_to_file(out_file, vuln_codename)
  out_file << vuln_codename
end

def vuln_codename_in_base?(vuln_codename)
  Vulnerability.find_by_codename(vuln_codename.strip).present?
end
