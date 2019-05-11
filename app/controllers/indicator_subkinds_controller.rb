# frozen_string_literal: true

class IndicatorSubkindsController < ApplicationController
  include Record

  private

  def model
    IndicatorSubkind
  end
end
