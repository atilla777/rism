# frozen_string_literal: true

class TagKindsController < ApplicationController
  include Record

  private

  def model
    TagKind
  end
end
