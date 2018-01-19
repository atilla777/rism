class RolesController < ApplicationController
  include Record

  private
  def get_model
    Role
  end
end
