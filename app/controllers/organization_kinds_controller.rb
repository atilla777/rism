class OrganizationKindsController < ApplicationController
  include Record

  private
  def get_model
    OrganizationKind
  end
end
