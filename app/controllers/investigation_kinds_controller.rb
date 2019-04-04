# frozen_string_literal: true

class InvestigationKindsController < ApplicationController
  include Record

  private

  def model
    InvestigationKind
  end
end
