# frozen_string_literal: true

class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig
  include Linkable
  include Tagable
  include Attachable

  has_paper_trail ignore: %i[password]

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

  belongs_to :organization

  belongs_to :department, optional: true

  has_many :incidents, dependent: :restrict_with_error

  has_many :rights, as: :subject, dependent: :destroy

  def show_full_name
    name
  end

  private

  def set_organization_id
    self.organization_id = department.organization_id
  end
end
