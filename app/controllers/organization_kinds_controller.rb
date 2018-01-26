# frozen_string_literal: true

class OrganizationKindsController < ApplicationController
  include Record

  private

  def model
    OrganizationKind
  end
end
