# frozen_string_literal: true

class LinkKindsController < ApplicationController
  include Record

  private

  def model
    LinkKind
  end

  def default_sort
    'first_record_type asc'
  end
end
