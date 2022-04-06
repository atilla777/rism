# frozen_string_literal: true

class TaskStatusesController < ApplicationController
  include Record

  private

  def model
    TaskStatus
  end
end
