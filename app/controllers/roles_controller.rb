# frozen_string_literal: true

class RolesController < ApplicationController
  include Record

  private

  def model
    Role
  end
end
