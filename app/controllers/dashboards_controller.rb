# frozen_string_literal: true

class DashboardsController < ApplicationController
  def index
    authorize :dashboards
  end
end
