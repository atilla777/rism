# frozen_string_literal: true

# It assumes that bootstrap, awesome font and slim is used in the Rails project.
module PortLegalityHelper

  def port_current_legality(record)
    legality, color = ScanResultDecorator.new(record).show_current_legality_with_color
    render(
      'helpers/port_legality', record: record, color: color, legality: legality
    )
  end

  def port_legality(record)
    legality, color = ScanResultDecorator.new(record).show_legality_with_color
    render(
      'helpers/port_legality', record: record, color: color, legality: legality
    )
  end
end
