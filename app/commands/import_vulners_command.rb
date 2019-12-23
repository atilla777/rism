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
  end

  private

  def self.bdu_csv(file)
    ImportVulnersCommand::BduCsv.new(file)
      .execute
  end
end
