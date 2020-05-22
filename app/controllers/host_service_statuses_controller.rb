# frozen_string_literal: true

class HostServiceStatusesController < ApplicationController
  include Record

  private

  def model
    HostServiceStatus
  end
end
