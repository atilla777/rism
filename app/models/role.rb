# frozen_string_literal: true

class Role < ApplicationRecord
  before_destroy :protect_main_roles

  has_many :role_members, dependent: :destroy
  has_many :users, through: :role_members

  has_many :rights, dependent: :destroy

  validates :name, length: { minimum: 3, maximum: 100 }
  validates :name, uniqueness: true

  # Prevent builtin roles (like an Administrator, Editor, Reader)
  # to be deleted
  def protect_main_roles
    return unless (1..3).cover?(id)
    errors.add(:base, :role_is_built_in)
    throw :abort
  end
end
