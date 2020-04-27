class CustomReportsResult < ApplicationRecord
  include OrganizationAssociated
  include Rightable

  after_create :remove_old_results
  before_destroy :delete_result_file

  validates :custom_report_id, numericality: { only_integer: true, allow_blank: true }

  belongs_to :custom_report
  has_one :organization, through: :custom_report

  def result_file_path
    "#{record_storage_dir}/#{result_path}"
  end

  def record_storage_dir
    custom_report.result_storage_dir
  end

  def organization_id
    organization.id
  end

  private

  # Remove old results (stay only 5 last)
  def remove_old_results
    CustomReportsResult.where(custom_report_id: custom_report_id)
      .order('created_at DESC')
      .offset(5)
      .destroy_all
  end

  # Delete folder with report results files
  def delete_result_file
    return unless result_path.present?
    file_path = result_file_path
    File.delete(file_path) if File.exist?(file_path)
  end
end
