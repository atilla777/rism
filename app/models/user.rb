class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig

  validates :email, presence: true, if: Proc.new { | r | r.active == true }
  validates :job_rank, numericality: { only_integer: true, allow_blank: true }
  validates :department_id, numericality: { only_integer: true, allow_blank: true }

  has_many :rights, as: :subject, dependent: :destroy

  belongs_to :department, optional: true
end
