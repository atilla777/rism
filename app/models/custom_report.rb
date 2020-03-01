class CustomReport < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  RESULT_FORMATS = {
    csv: 'csv',
    json: 'json'
  }.freeze

  enum result_format: RESULT_FORMATS, _prefix: true

  validates :name, length: { minimum: 3, maximum: 300 }
  validates :organization_id, numericality: { only_integer: true }
  validates :folder_id, numericality: { only_integer: true, allow_blank: true }
  validates :result_format, inclusion: { in: CustomReport.result_formats.values }
  validates :statement, presence: true

  belongs_to :custom_reports_folder, foreign_key: :folder_id, optional: true
  belongs_to :organization
end
