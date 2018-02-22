# frozen_string_literal: true

class TagsController < ApplicationController
  include Record

  before_action :set_tag_kinds, only: [:new, :create, :edit, :update]

  private

  def model
    Tag
  end

  def set_tag_kinds
    @tag_kinds = TagKind.all.order(:name)
  end

  def default_includes
    %i[tag_kind]
  end

  def default_sort
    'tag_kind_code_name asc, name asc'
  end
end
