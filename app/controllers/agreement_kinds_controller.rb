# frozen_string_literal: true

class AgreementKindsController < ApplicationController
  include Record

  private

  def model
    AgreementKind
  end
end
