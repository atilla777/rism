# frozen_string_literal: true

class ChartsController < ApplicationController
  def show
    authorize :charts
    render(
      json: Charts.chart_by_name(params[:name])
        .new(current_user, params)
        .chart_data
    )
  end
end
