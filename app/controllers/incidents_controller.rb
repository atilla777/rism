# frozen_string_literal: true

class IncidentsController < ApplicationController
  include Record

  private

  def model
    Incident
  end

  def default_sort
    'id desc'
  end
end
