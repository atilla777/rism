# frozen_string_literal: true

class ImportVulnersCommand
  FILE_FORMATS = %i[
    bdu_csv
  ]

  def self.file_formats
    FILE_FORMATS
  end

  def self.call(file, file_format)
    self.send(file_format.to_sym, file)
#    {
#      errors: @errors,
#      created_cve_list: @created_cve_list,
#      rows_processed: @rows_processed
#    }
#    new.execute(*args, &block)
#    {
#      errors: result[:errors],
#      created_cve_list: result[:created_cve_list],
#      rows_processed: result[:rows_processed]
#    }
  end

#  def initialize(file, file_format)
#    @file = file
#    @file_format = file_format
#    @errors = []
#    @created_cve_list = {}
#    @rows_processed = 0
#  end

#  def execute
#  end

  private

  def self.bdu_csv(file)
    ImportVulnersCommand::BduCsv.new(file)
      .execute
  end
end
