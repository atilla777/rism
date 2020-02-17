# frozen_string_literal: true

class RolesController < ApplicationController
  include Record

  autocomplete(:role, :name, full: true)

  # authorization for autocomplete
  def active_record_get_autocomplete_items(parameters)
    authorize model
    if current_user.admin?
      super(parameters)
    end
  end

  def show
    @record = record
    authorize @record.class
  end

  private

  def model
    Role
  end
end
