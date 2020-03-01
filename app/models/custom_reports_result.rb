class CustomReportsResult < ApplicationRecord
  include OrganizationAssociated
  include Rightable

  validates :custom_report_id, numericality: { only_integer: true, allow_blank: true }

  belongs_to :custom_report
  has_one :organization, through: :custom_report
end
