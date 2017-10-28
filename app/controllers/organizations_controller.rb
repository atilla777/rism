class OrganizationsController < ApplicationController
  include DefaultActions

  autocomplete :organization, :name, full: true

  private
  def get_model
    Organization
  end

  def permit_attributes
    %i[name parent_id kind description]
  end
end
