# frozen_string_literal: true

module Tagable
  extend ActiveSupport::Concern

  included do
    has_many :tag_members, as: :record, dependent: :delete_all
    has_many :tags, through: :tag_members
    has_many :tag_kinds, through: :tags
  end
end

