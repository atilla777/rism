# frozen_string_literal: true

class TaskPrioritiesController < ApplicationController
  include Record

  private

  def model
    TaskPriority
  end
end
