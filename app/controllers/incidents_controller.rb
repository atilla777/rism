# frozen_string_literal: true

class IncidentsController < ApplicationController
  include Record

  before_action :set_time, only: [:create, :update]

  private

  def model
    Incident
  end

  def default_sort
    'id desc'
  end

  def set_time
    %w[discovered started finished].each do |field|
    hours = params[:incident]["#{field}_at(4i)"]
    minutes = params[:incident]["#{field}_at(5i)"]
      if hours.present? && minutes.present?
        params[:incident]["#{field}_time"] = '1'
      else
        params[:incident]["#{field}_time"] = '0'
      end
    end
  end
end
