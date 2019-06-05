# frozen_string_literal: true

class VulnerabilitiesController < ApplicationController
  include Record

  before_action :set_time, only: [:create, :update]

  def search
    if params[:actual_and_relevant]
      actual_and_relevant
    else
      index
      render 'index'
    end
  end

  def actual_and_relevant
    authorize model
    @actual_and_relevant = true
    scope = model.actual_and_relevant
    @records = records(scope)
    render 'vulnerabilities/_actual_and_relevant'
  end

  def toggle_processed
    record.toggle!(:processed)
    @record = VulnerabilityDecorator.new(record)
  end

  private

  def model
    Vulnerability
  end

  def default_sort
    'modified desc'
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

  def set_custom_fields
    @custom_fields = CustomField.where(field_model: model.model_name.to_s)
  end
end
