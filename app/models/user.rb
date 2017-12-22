class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig

  validates :organization_id, numericality: { only_integer: true }
  validates :email, presence: true, if: Proc.new { | r | r.active == true }
  # TODO remove unused field
  validates :job_rank, numericality: { only_integer: true, allow_blank: true }
  validates :department_id, numericality: { only_integer: true, allow_blank: true }
  validates :department_name, length: { in: 1..100, allow_blank: true}
  validates :rank, numericality: { only_integer: true, allow_blank: true }

  before_save :set_organization_id, if: -> (obj) { obj.department_id.present? }

  belongs_to :department, optional: true

  private
  def set_organization_id
    self.organization_id = self.department.organization_id
  end
end
