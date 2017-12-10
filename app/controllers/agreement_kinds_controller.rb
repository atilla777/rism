class AgreementKindsController < ApplicationController
  include DefaultMethods
  include DefaultActions

  private
  def get_model
    AgreementKind
  end
end
