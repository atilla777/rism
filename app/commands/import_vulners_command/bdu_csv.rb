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
    @rows_processed = 0
    @queue = []
  end

  def execute
    CSV.foreach(
      @file.path,
         encoding:'windows-1251:utf-8',
         col_sep: ';',
         headers: CSV_HEADERS
       ) do |row|
       @rows_processed += 1
       queue_to_save(row.to_h)
    end
    save if @queue.present?

    {
      errors: @errors,
      created_vulns: @created_vulns,
      rows_processed: @rows_processed
    }
  end

  private

  def queue_to_save(row)
    attributes = attributes_from_row(row)
    return unless attributes[:codename].present?
    @queue << Vulnerability.new(attributes)
    return if @queue.size < Vulnerability.mass_save_limit
    save
  end

  def save
    result = Vulnerability.mass_save(
      @queue,
      returned_field: :codename
    )
    @created_vulns = @created_vulns.merge(
      result.results
      .zip(result.ids.map(&:to_i))
            .to_h
    )
    @errors += result.failed_instances
    @queue = []
  end

#  def custom_codenames(existing_codenames, bdu_id)
#    bdu_id = bdu_id[/BDU:\d+-\d+/]
#    return existing_codenames if existing_codenames.include?(bdu_id)
#    existing_codenames << bdu_id
#  end

  def attributes_from_row(row)
    attributes = {}
    attributes[:codename] = row[:bdu_id][/BDU:\d+-\d+/]
    return attributes unless attributes[:codename].present?
    attributes[:custom_codenames_str] = row[:codenames]
    #codenames = row[:codenames] # cve and other names
    #cve = codenames[/CVE-\d+-\d+/] if codenames.present?
#    if cve.present?
#      attributes[:codename] = cve
#      attributes[:custom_codenames_str] = bdu_and_codenames
#    else
#      attributes[:codename] = bdu_id
#      attributes[:custom_codenames_str] = codenames
#    end
#    return attributes if attributes[:codename].blank?
    attributes[:raw_data] = row.to_h
    attributes[:feed] = Vulnerability.feeds[:bdu]
    attributes[:vendors] = str_to_arr(row[:vendor])
    attributes[:products] = str_to_arr(row[:product])
    if row[:cwe].present?
      attributes[:cwe] = row[:cwe].split(',')
    else
      attributes[:cwe] = []
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

    # When Activerecord import used create calback not work, so ...
    attributes[:published] = attributes[:custom_published]
    attributes[:published_time] = false
    attributes[:modified] = attributes[:published]
    attributes[:modified_time] = false
    attributes[:state] = 'published'
#    attributes[:actuality] = Custom::VulnerabilityCustomization.cast_actuality(
#      OpenStruct.new(attributes.slice(:cvss3, :cvss2))
#    )
    # TODO: what with changed_fields?

    attributes
  end

  def str_to_arr(string)
    return unless string
    string.split(',')
          .map(&:strip)
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
