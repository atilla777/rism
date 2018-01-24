class AgreementKindsController < ApplicationController
  include Record

  private

  def model
    AgreementKind
  end
end
