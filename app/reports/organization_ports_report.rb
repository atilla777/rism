# frozen_string_literal: true

class OrganizationPortsReport < BaseReport
  set_lang :ru
  set_report_name :organization_ports
  set_human_name 'Открытые порты организации'
  set_report_model 'ScanResults'
  #set_required_params %i[organization_id]
  set_required_params %i[]

  def report(r)
    organization = OrganizationPolicy::Scope.new(current_user, Organization).resolve
      .where(id: options[:organization_id]).first

    r.p  "Справка по открытым портам хостов организации #{organization.name}", style: 'Header'
    r.p  "(по состоянию на #{Date.current.strftime('%d.%m.%Y')})", style: 'Prim'

    scope = ScanResult
    scope = scope.where(state: :open)
    records = ScanResultsQuery.new(scope)
                            .last_results
                            #.includes(records_includes)
    records.each do |record|
      r.p
      r.p "#{record.ip}; #{record.port}; #{record.protocol}"
    end
  end
end
