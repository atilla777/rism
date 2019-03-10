# frozen_string_literal: true

class InvestigationsController < ApplicationController
  include RecordOfOrganization

  private

  def model
    Investigation
  end

  def records_includes
    %i[organization user feed]
  end

  def default_sort
    'created_at desc'
  end
end
