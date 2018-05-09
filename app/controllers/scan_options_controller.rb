# frozen_string_literal: true

class ScanOptionsController < ApplicationController
  include Record

  private

  def model
    ScanOption
  end
end
