# frozen_string_literal: true

class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig

  validates :organization_id, numericality: { only_integer: true }
  validates :email, presence: true, if: proc { |r| r.active == true }
  validates :department_id,
            numericality: { only_integer: true, allow_blank: true }
  validates :department_name,
            length: { in: 1..100, allow_blank: true }
  validates :rank,
            numericality: { only_integer: true, allow_blank: true }

  before_save :set_organization_id,
              if: ->(obj) { obj.department_id.present? }

  belongs_to :department, optional: true

  has_many :rights, as: :subject, dependent: :destroy

  private

  def set_organization_id
    self.organization_id = department.organization_id
  end
end
