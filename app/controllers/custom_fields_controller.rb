# frozen_string_literal: true

class CustomFieldsController < ApplicationController
  include Record

  private

  def model
    CustomField
  end
end
