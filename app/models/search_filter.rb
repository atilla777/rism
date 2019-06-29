# frozen_string_literal: true

class SearchFilter < ApplicationRecord
  include OrganizationMember

  validates :name, length: { in: 3..100 }
  validates :user_id, numericality: { only_integer: true }

  belongs_to :user
end
