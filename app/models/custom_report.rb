class CustomReport < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  enum report_format: {
    csv: 'not_set',
    json: 'for_detect'
  }, _prefix: true

  validates :name, length: { minimum: 3, maximum: 300 }
  validates :user_id, numericality: { only_integer: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :custom_reports_folder_id, numericality: { only_integer: true }

  belongs_to :custom_reports_folder, optional: true
  belongs_to :organization
  belongs_to :user
end
