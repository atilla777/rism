class OrganizationsController < ApplicationController
  include DefaultActions

  private
  def get_model
    Organization
  end

  def permit_attributes
    %i[name description]
  end
end
