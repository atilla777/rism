# frozen_string_literal: true

class ImportVulnersCommand
  FILE_FORMATS = %i[
    bdu_csv
  ]

  def self.file_formats
    FILE_FORMATS
  end

  def self.call(*args, &block)
    result = new(*args, &block).execute
    {
      errors: result[:errors],
      created_cve_list: result[:created_cve_list],
      rows_processed: result[:rows_processed]
    }
  end

  def initialize(file, file_format)
    @file = file
    @file_format = file_format
    @errors = []
    @created_cve_list = {}
    @rows_processed = 0
  end

  def execute
    self.send(@file_format.to_sym)
    {
      errors: @errors,
      created_cve_list: @created_cve_list,
      rows_processed: @rows_processed
    }
  end

  private

  def bdu_csv
    CSV.foreach(@file.path, encoding:'windows-1251:utf-8', col_sep: ';') do |row|
      create_if_not_exist(row_to_params(row))
    end
  end

  def row_to_params(row)
    attributes = {}
    row_18 = row[18]
    return attributes if row_18.blank?
    attributes[:codename] = row_18[/CVE-\d+-\d+/]
    return attributes if  attributes[:codename].blank?
    @rows_processed +=1
    attributes[:custom_codenames_str] = row[0]
    attributes[:feed] = Vulnerability.feeds[:custom]
    attributes[:custom_vendors_str] = row[3]
    attributes[:custom_products_str] = row[4]
    if attributes[:cwe] = row[21]
      attributes[:cwe] = row[21].split(',')
    end
    attributes[:cvss3_vector] = row[11]
    attributes[:cvss2_vector] = row[10]
    attributes[:custom_description] = [row[2], row[5]].join(
      ". #{I18n.t('activerecord.attributes.vulnerability.versions')}: "
    )
    attributes[:custom_references] = row[17]
    if row[9].present?
      attributes[:custom_published] = Date.strptime(row[9], '%d.%m.%Y')
    end
    attributes
  end

  def create_if_not_exist(attributes)
    return if attributes[:codename].blank?
    record = Vulnerability.where(codename: attributes[:codename])
      .first_or_create do |record|
        record.attributes = attributes
        @created_cve_list[record.codename] = true
      end
    if @created_cve_list[record.codename]
      @created_cve_list[record.codename] = record.id
    end
  rescue ActiveRecord::RecordInvalid
    @errors << record.errors
  end
end
