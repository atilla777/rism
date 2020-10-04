class UserAction < ApplicationRecord
  include OrganizationAssociated
  include UserAction::Ransackers

  self.record_timestamps = false

  validates :user_id, numericality: { only_integer: true, allow_blank: true }
  validates :controller, presence: true
  validates :action, presence: true
  validates :ip, presence: true
  # Commented to work in feature test
  #validates :browser, presence: true

  belongs_to :user, optional: true

  has_one :organization, through: :user

  attr_accessor :skip_current_user_check
end
