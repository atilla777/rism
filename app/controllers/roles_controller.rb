class RolesController < ApplicationController
  include DefaultActions

  private
  def get_model
    Role
  end
end
