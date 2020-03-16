class CustomReportsResult < ApplicationRecord
  include OrganizationAssociated
  include Rightable

  before_destroy :delete_result_files

  validates :custom_report_id, numericality: { only_integer: true, allow_blank: true }

  belongs_to :custom_report
  has_one :organization, through: :custom_report

  def result_file
    result_path.sub("#{record_storage_dir.to_s}/", '')
  end

  private

  # Delete folder with article images
  def delete_result_files
    FileUtils.rm_rf(record_storage_dir) if File.directory?(record_storage_dir)
  end

  def record_storage_dir
    Rails.root.join(
      'file_storage',
      'custom_reports',
      id.to_s
    )
  end
end
