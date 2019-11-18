# frozen_string_literal: true

class Charts
  @@charts = {}

  def self.charts
    @@charts
  end

  def self.add_chart(chart_class)
    @@charts[chart_class.chart_name.to_sym] = chart_class
  end

  def self.chart_by_name(name)
    @@charts[name.to_sym]
  end

  def self.charts
    @@charts
  end

  IncidentsByStateChart.register
  IncidentsByDays.register
  IncidentsByRegistrator.register
  IncidentsByOrganizations.register
  IncidentsBySeveryties.register
  IncidentsByNameChart.register
  PortsByOrganizations.register
  IllegalPortsByOrganizations.register
  VulnerablePortsByOrganization.register
  ScanByDays.register
  LongestScanJobsChart.register
  TopIndicators.register
  IndicatorsByDays.register
  IndicatorsByUsers.register
  IndicatorsByFormat.register
  NetworkIndicators.register
  EmailIndicators.register
  TopVulnerabilitiesProcessors.register
  VulnerabilitiesByDays.register
  VulnerabilitiesBulletinsByDays.register
  ActualAndRelevantVulnerabilitiesByDays.register
  TopCweByMonth.register
  TopCveScoreByMonth.register
  ActionsByDays.register
  TopUsersFromUserActionsByMonth.register
  FailedLoginsByDays.register
  TopOrganizationsFromUserActionsByMonth.register
end
