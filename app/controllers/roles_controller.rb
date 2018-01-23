class RolesController < ApplicationController
  include Record

  private
  def model
    Role
  end
end
