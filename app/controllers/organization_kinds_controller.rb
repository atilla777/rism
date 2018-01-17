class OrganizationKindsController < ApplicationController
  include DefaultActions

  private
  def get_model
    OrganizationKind
  end
end
