# frozen_string_literal: true

class DashboardsController < ApplicationController
  def index
    authorize :dashboards
  end

  def show
    authorize :dashboards
    @chart = params[:name]
  end

  def investigations_dashboard
    authorize Investigation
  end
end
