# frozen_string_literal: true

class VulnerabilitiesController < ApplicationController
  include Record

  private

  def model
    Vulnerability
  end

  def default_sort
    'published desc'
  end
end
