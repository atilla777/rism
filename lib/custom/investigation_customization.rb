module Custom
  module InvestigationCustomization
    module_function

    def cast_custom_codename(investigation)
      now = Time.now
      last_number = Investigation.select(:custom_codename)
        .order(id: :asc)
        .last(2)
        .first
        &.custom_codename
        &.scan(/\d+$/)
        &.last
        &.to_i || -1
      "#{now.strftime('%d.%m.%Y')}/#{(last_number + 1)}"
    end
  end
end
