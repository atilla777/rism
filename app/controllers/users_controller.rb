class UsersController < ApplicationController
  include DefaultActions

  def new
    super
    @organizations = get_organizations
  end

  def create
    @organizations = get_organizations
    super
  end

  def edit
    super
    @organizations = get_organizations
  end

  def update
    @organizations = get_organizations
    super
  end

  private
  def get_model
    User
  end

  def get_organizations
    Organization.all
  end

  def permit_attributes
    %i[name
       organization_id
       email
       phone
       mobile_phone
       job
       active
       password
       password_confirmation
       description]
  end
end
