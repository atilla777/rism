class OrganizationKindsController < ApplicationController
  include Record

  private
  def model
    OrganizationKind
  end
end
