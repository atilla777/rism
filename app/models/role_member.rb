# frozen_string_literal: true

class RoleMember < ApplicationRecord
  belongs_to :user
  belongs_to :role

  validates :user_id, numericality: { only_integer: true }
  validates :role_id, numericality: { only_integer: true }

  validates(
    :user_id,
    uniqueness: { scope: :role_id}
  )
end
