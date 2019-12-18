# frozen_string_literal: true

class ImportVulnersCommand
  FILE_FORMATS = %i[
    bdu_csv
  ]

  def self.file_formats
    FILE_FORMATS
  end

  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(file, file_format)
    @file = file
    @file_format = file_format
  end

  def execute
    self.send(@file_format.to_sym)
  end

  private

  def bdu_csv
    #, headers: true
    CSV.foreach(@file.path, col_sep: ';') do |row|
      errors = create_if_not_exist(row_to_params(row))
      return errors if errors
    end
    nil
  end

  def row_to_params(row)
    attributes = {}
    attributes[:codename] = row[18][/CVE-\d+-\d+/]
    attributes[:custom_codenames_str] = row[0]
    attributes[:feed] = Vulnerability.feeds[:custom]
    attributes[:custom_vendors_str] = row[3]
    attributes[:custom_products_str] = row[4]
    attributes[:cwe] = [row[21]]
    attributes[:custom_cvss3_vector] = row[11]
    attributes[:cvss2_vector] = row[10]
    attributes[:custom_description] = [row[2], row[5]].join(
      ". #{I18n.t('activerecord.attributes.vulnerability.versions')}: "
    )
    attributes[:custom_references] = row[17]
    attributes[:custom_published] = Date.strptime(row[9], '%d.%m.%Y')
    attributes
  end

  def create_if_not_exist(attributes)
    return if attributes[:codename].blank?
    record = Vulnerability.where(codename: attributes[:codename])
      .first_or_create! do |record|
        record.attributes = attributes
      end
    nil
  rescue ActiveRecord::RecordInvalid
    return record.errors
  end
end
