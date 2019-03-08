# frozen_string_literal: true

class FeedsController < ApplicationController
  include Record

  private

  def model
    Feed
  end
end
