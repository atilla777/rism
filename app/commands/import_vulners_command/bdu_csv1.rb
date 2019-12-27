class ImportVulnersCommand::BduCsv
  CVSS3_REGEXP = %r{
    CVSS\s+3.[0-1]{1}\s+составляет\s+(10|[1-9]{1},\d{1}|\d{1})\s*\)
  }x.freeze

  CVSS2_REGEXP = %r{
    CVSS\s+2.0\s+составляет\s+(10|[1-9]{1},\d{1}|\d{1})\s*\)
  }x.freeze

  CSV_HEADERS = %i[
    bdu_id
    name
    description
    vendor
    product
    version
    soft_type
    os_and_harware
    vuln_class
    detection_date
    cvss2_vector
    cvss3_vector
    danger_level
    controls
    status
    exploit
    resolved
    references
    codenames
    other
    cwe_description
    cwe
  ]

  def initialize(file)
    @file = file
    @errors = []
    @created_vulns = {}
    @updated_vulns = {}
    @rows_processed = 0
  end

  def execute
    CSV.foreach(
      @file.path,
      encoding:'windows-1251:utf-8',
      col_sep: ';',
      headers: CSV_HEADERS
    ) do |row|
      save_do_database(row)
    end
    {
      errors: @errors,
      created_vulns: @created_vulns,
      updated_vulns: @updated_vulns,
      rows_processed: @rows_processed
    }
  end

  private

  def save_do_database(row)
    attributes = attributes_from_row(row)#.merge(skip_versioning: true)
    return if attributes[:codename].blank?

    record = Vulnerability.where(
      codename: attributes[:codename]
    ).first_or_initialize


    if record.new_record? # Add new vulnerability with BDU ID
      record.attributes = attributes
      record.save!
      @created_vulns[record.codename] = record.id
    elsif record.feed == 'nvd' # Only try to add BDU ID to existing CVE
      record.custom_codenames = custom_codenames(
        record.custom_codenames, row[:bdu_id]
      )
      record.save!
      @updated_vulns[record.codename] = record.id
    end

  rescue ActiveRecord::RecordInvalid => errors
      @created_cve_list.reject! { |k, _v| k == attributes[:codename]}
      @errors << {codename: attributes[:codename], errors: errors}
  end

  def custom_codenames(existing_codenames, bdu_id)
    bdu_id = bdu_id[/BDU:\d+-\d+/]
    return existing_codenames if existing_codenames.include?(bdu_id)
    existing_codenames << bdu_id
  end

  def attributes_from_row(row)
    attributes = {}
    bdu_id = row[:bdu_id][/BDU:\d+-\d+/]
    codenames = row[:codenames] # cve and other names
    cve = codenames[/CVE-\d+-\d+/] if codenames.present?
    bdu_and_codenames = if codenames.present?
                          [bdu_id, codenames].compact.join(',')
                        else
                          bdu_id
                        end
    if cve.present?
      attributes[:codename] = cve
      attributes[:custom_codenames_str] = bdu_and_codenames
    else
      attributes[:codename] = bdu_id
      attributes[:custom_codenames_str] = codenames
    end
    return attributes if attributes[:codename].blank?
    @rows_processed +=1
    attributes[:raw_data] = row.to_h
    attributes[:feed] = Vulnerability.feeds[:bdu]
    attributes[:custom_vendors_str] = row[:vendor]
    attributes[:custom_products_str] = row[:product]
    if row[:cwe].present?
      attributes[:cwe] = row[:cwe].split(',')
    end
    attributes[:cvss3_vector] = row[:cvss3_vector]
    attributes[:cvss2_vector] = row[:cvss2_vector]
    attributes[:custom_description] = custom_description(row)
      attributes[:custom_references] = row[:references]
    if row[:detection_date].present?
      attributes[:custom_published] = Date.strptime(
        row[:detection_date], '%d.%m.%Y'
      )
    else
      attributes[:custom_published] = DateTime.now
    end
    attributes[:cvss3] = cvss3(row[:danger_level])
    attributes[:cvss2] = cvss2(row[:danger_level])
    attributes
  end

  def custom_description(row)
    versions = if row[:version].present?
      "#{I18n.t('activerecord.attributes.vulnerability.versions')}: #{row[:version]}"
    end
    [
      row[:description],
      versions
    ].compact.join('. ')
  end

  def cvss3(cvss3)
    return nil unless cvss3.present?
    cvss = cvss3[CVSS3_REGEXP, 1]
    if cvss.present?
      cvss.gsub(',', '.').to_f
    end
  end

  def cvss2(cvss2)
    return nil unless cvss2.present?
    cvss = cvss2[CVSS2_REGEXP, 1]
    if cvss.present?
      cvss.gsub(',', '.').to_f
    end
  end
end
