class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig

  validates :email, presence: true, if: Proc.new { | r | r.active == true }
  validates :job_rank, numericality: { only_integer: true, allow_blank: true }
  validates :department_id, numericality: { only_integer: true, allow_blank: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :department_name, length: { in: 1..100, allow_blank: true}
  validates :rank, numericality: { only_integer: true, allow_blank: true }

  before_save :set_organization_id, if: -> (obj) { obj.department_id.present? }

  has_many :rights, as: :subject, dependent: :destroy

  belongs_to :department, optional: true

  private

  def set_organization_id
    self.organization_id = self.department.organization_id
  end
end
