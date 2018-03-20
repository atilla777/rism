# frozen_string_literal: true

module ChartHelper
  def chart(name, options = {})
    chart = Charts.chart_by_name(name)
    render(
      'helpers/chart',
      chart: chart,
      options: options
    )
  end
end
