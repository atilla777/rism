class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig

  validates :email, presence: true, if: Proc.new { | r | r.active == true }

  has_many :rights, as: :subject, dependent: :destroy
end
