module Custom
  module InvestigationCustomization
    module_function

#    def cast_custom_codename(investigation)
#      now = Time.now
#      last_number = Investigation.select(:custom_codename)
#        .order(id: :asc)
#        .last(2)
#        .first
#        &.custom_codename
#        &.scan(/\d+$/)
#        &.last
#        &.to_i || -1
#      "#{now.strftime('%d.%m.%Y')}/#{(last_number + 1)}"
#    end

    def cast_custom_codename(investigation)
      start_day = Time.zone.now.beginning_of_day
      oc = investigation.organization.codename
      last_number = Investigation.select(:custom_codename, :id)
        .where('created_at >= ?', start_day)
        .where(organization_id: investigation.organization_id)
        .order(id: :desc)
        .first
        &.custom_codename
        &.scan(/\d+$/)
        &.first
        &.to_i || 0
        "#{start_day.strftime('%d.%m.%Y')}-#{oc}-#{(last_number + 1)}"
    end
  end
end
