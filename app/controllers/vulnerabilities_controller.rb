# frozen_string_literal: true

class VulnerabilitiesController < ApplicationController
  include Record

  before_action :set_time, only: [:create, :update]

  private

  def model
    Vulnerability
  end

  def default_sort
    'published desc'
  end

  def set_time
    %w[published].each do |field|
    hours = params[:vulnerability]["#{field}_at(4i)"]
    minutes = params[:vulnerability]["#{field}_at(5i)"]
      if hours.present? && minutes.present?
        params[:vulnerability]["#{field}_time"] = '1'
      else
        params[:vulnerability]["#{field}_time"] = '0'
      end
    end
  end
end
