# frozen_string_literal: true

class IndicatorContextsController < ApplicationController
  include Record

  private

  def model
    IndicatorContext
  end
end
