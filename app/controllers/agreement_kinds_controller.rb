class AgreementKindsController < ApplicationController
  include Record

  private
  def get_model
    AgreementKind
  end
end
