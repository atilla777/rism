class ImportVulnersCommand::BduCsv
  CVSS3_REGEXP = %r{
    CVSS\s+3.0\s+составляет\s+(10|[1-9]{1}.\d{1}|[1-9]{1})\)
  }x.freeze

  CVSS2_REGEXP = %r{
    CVSS\s+2.0\s+составляет\s+(10|[1-9]{1}.\d{1}|[1-9]{1})\)
  }x.freeze

  def initialize(file)
    @file = file
    @errors = []
    @created_cve_list = {}
    @rows_processed = 0
  end

  def execute
    CSV.foreach(@file.path, encoding:'windows-1251:utf-8', col_sep: ';') do |row|
      create_if_not_exist(row_to_params(row))
    end
    {
      errors: @errors,
      created_cve_list: @created_cve_list,
      rows_processed: @rows_processed
    }
  end

  private

  def row_to_params(row)
    attributes = {}
    bdu = row[0][/BDU:\d+-\d+/]
    codenames = row[18] # cve and other names
    cve = codenames[/CVE-\d+-\d+/] if codenames.present?
    bdu_and_codenames = if codenames.present?
                          [bdu, codenames].compact.join(',')
                        else
                          bdu
                        end
    if cve.present?
      attributes[:codename] = cve
      attributes[:custom_codenames_str] = bdu_and_codenames
    else
      attributes[:codename] = bdu
      attributes[:custom_codenames_str] = codenames
    end
    return attributes if  attributes[:codename].blank?
    @rows_processed +=1
    attributes[:feed] = Vulnerability.feeds[:bdu]
    attributes[:custom_vendors_str] = row[3]
    attributes[:custom_products_str] = row[4]
    if attributes[:cwe] = row[21]
      attributes[:cwe] = row[21].split(',')
    end
    attributes[:cvss3_vector] = row[11]
    attributes[:cvss2_vector] = row[10]
    attributes[:custom_description] = [row[2], row[5]].compact.join(
      ". #{I18n.t('activerecord.attributes.vulnerability.versions')}: "
    )
    attributes[:custom_references] = row[17]
    if row[9].present?
      attributes[:custom_published] = Date.strptime(row[9], '%d.%m.%Y')
    end
    attributes[:exploit_maturity] = exploit_maturity(row[15])
    attributes[:cvss3] = cvss3(row[12])
    attributes[:cvss2] = cvss2(row[12])
    attributes
  end

  def exploit_maturity(row_15)
    case row_15
    when ''
      'not_defined'
    when 'Существует'
      'high'
    when ''
      'functional'
    when
      'poc'
    when ''
      'unproven'
    end
  end

  def cvss3(row_12)
    return nil unless row_12.present?
    row_12[CVSS3_REGEXP, 1]
  end

  def cvss2(row_12)
    return nil unless row_12.present?
    row_12[CVSS2_REGEXP, 1]
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
