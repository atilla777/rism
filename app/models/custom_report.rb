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

  after_destroy :delete_result_folder

  validates :name, length: { minimum: 3, maximum: 300 }
  validates :name, uniqueness: { scope: [:folder_id, :result_format] }
  validates :organization_id, numericality: { only_integer: true }
  validates :folder_id, numericality: { only_integer: true, allow_blank: true }
  validates :result_format, inclusion: { in: CustomReport.result_formats.values }
  validates :statement, presence: true

  validate :statement_danger_commands

  belongs_to :custom_reports_folder, foreign_key: :folder_id, optional: true
  belongs_to :organization
  has_many :custom_reports_results, dependent: :destroy

  has_one :schedule, as: :job, dependent: :destroy

  def encoding
    return 'UTF-8' if utf_encoding?
    'Windows-1251'
  end

  def variables_arr
    CustomReportJob::Query.new(custom_report.statement).variables_arr
  end

  def worker
    'CustomReportJob'
  end

  def job_queue
    'custom_report'
  end

  def last_result
    custom_reports_results.last
  end

  def result_storage_dir
    Rails.root.join(
      'file_storage',
      'custom_reports',
      id.to_s
    )
  end

  private

  def delete_result_folder
    dir = result_storage_dir
    FileUtils.rm_rf(dir) if File.directory?(dir)
  end

  def statement_danger_commands
    return unless statement.match? /\b(drop|delete|update|create|alter|grant|load|insert|lock|reindex|set|truncate)\b/i
    errors.add(:statement, 'Danger SQL commands can`t be used!')
  end
end
