class RolesController < ApplicationController
  include DefaultActions

  private
  def get_model
    Role
  end

  def permit_attributes
    %i[name description]
  end
end
