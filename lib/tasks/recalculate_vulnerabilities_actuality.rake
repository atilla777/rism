# frozen_string_literal: true

# Recalculate vulnerabilities actuality
# when Custom::VulnerabilityCustomization.cast_actuality(v) was changed
#
# To use run:
# rake rism:recalculate_vulnerabilities_actuality

namespace :rism do
  desc 'Recalculate vulnerabilities actuality.'
  task :recalculate_vulnerabilities_actuality, [:year] => [:environment] do |_task, args|
    if args[:year].present?
      recalculate_for_year args[:year]
      pp "#{args[:year]} finished"
    else
      (2002..Time.now.year).each do |year|
        recalculate_for_year year
        pp "#{year} finished"
      end
    end
  end
end

def recalculate_for_year(year)
  vulnerabilities = Vulnerability.where("codename LIKE 'CVE-#{year}%'")
  vulnerabilities.each do |vulnerability|
    set_actuality(vulnerability)
  end
end

def set_actuality(vulnerability)
  actuality = Custom::VulnerabilityCustomization.cast_actuality(vulnerability)
  vulnerability.actuality = actuality
  vulnerability.custom_actuality = actuality
  begin
    vulnerability.save!
  rescue => e
    pp "Import error #{line} - #{e}"
  end
end
