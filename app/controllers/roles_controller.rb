# frozen_string_literal: true

class RolesController < ApplicationController
  include Record

  def show
    @record = record
    authorize @record.class
  end

  private

  def model
    Role
  end
end
