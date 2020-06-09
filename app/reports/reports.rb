# frozen_string_literal: true

class Reports
  @@reports = []

  def self.reports
    @@reports
  end

  def self.add_report(report_class)
    @@reports << report_class
  end

  def self.names_where(options)
    @@reports.select do |report|
      next unless report.report_model == options[:report_model]
      next unless report.lang == I18n.locale
      (report.required_params - options[:params].keys.to_a).empty?
    end
  end

  def self.report_by_name(name)
    @@reports.find { |report| report.report_name.to_sym == name.to_sym }
  end

  OrganizationIncidentsReport.register
#  OrganizationsReport.register
  TablePortsReport.register
  NmapTablePortsReport.register
  ShodanTablePortsReport.register
  HostsReport.register
  ServicesReport.register
  NmapVsShodanReport.register
  FiltredTablePortsReport.register
  LostServicesReport.register
  ActualAndRelevantVulnerabilitiesReport.register
  InvestigationReport.register
#  ForBlockReport.register
#  ForDetectReport.register
#  IpForBlockReport.register
#  DomainForBlockReport.register
#  EmailForBlockReport.register
#  Md5ForBlockReport.register
#  UriForBlockReport.register
  FiltredTableVulnersReport.register
  FiltredTableIndicatorsReport.register
  UsersActivityReport.register
  FiltredHostsReport.register
  VulnerabilityBulletinReport.register
end
