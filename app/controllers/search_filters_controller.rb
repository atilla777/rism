# frozen_string_literal: true

class SearachFiltersController < ApplicationController
  include RecordOfOrganization

  private

  def model
    SearchFilter
  end

  def records_includes
    %i[organization user]
  end

  def default_sort
    'rank desc'
  end
end
