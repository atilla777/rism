class OrganizationKindsController < ApplicationController
  include DefaultMethods
  include DefaultActions

  private
  def get_model
    OrganizationKind
  end
end
