# frozen_string_literal: true

class OrganizationsReport < BaseReport
  set_lang :ru
  set_report_name :organizations
  set_human_name 'Организации'
  set_report_model 'Organization'
  set_required_params %i[]

  def report(r)
    organizations = OrganizationPolicy::Scope.new(current_user, Organization).resolve
    r.p  "Справка по организациям", style: 'Header'
    organizations.each_with_index do |organization, index|
      r.p
      r.p "#{index + 1}. #{organization.name}", style: 'Header'
      r.p "Описание: #{organization.description}", style: 'Text'
    end
  end
end
