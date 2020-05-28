# frozen_string_literal: true

  CSV_HEADERS = %i[
    ip
    organization
    description
  ]

class ImportHostsService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(file, organization_id, current_user)
    @file = file
    @organization_id = organization_id
    @current_user = current_user

    @not_processed_ips = []

    @errors = []
    @created_records = {}
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
       row_as_hash = row.to_h
       @not_processed_ips << row_as_hash[:ip]
       queue_to_save(row_as_hash)
    end
    save if @queue.present?

    {
      errors: @errors,
      created_records: @created_records,
      rows_processed: @rows_processed,
      not_processed_ips: @not_processed_ips
    }
  end

  private

  def queue_to_save(row)
    attributes = attributes_from_row(row)
    return unless attributes[:ip].present?
    @queue << Host.new(attributes)
    return if @queue.size < Host.mass_save_limit
    save
  end

  def save
    result = Host.mass_save(
      @queue,
      returned_field: :ip,
      on_duplicate_key_ignore: true
    )
    @not_processed_ips = @not_processed_ips - result.results.map { |ip| IPAddr.new(ip).to_cidr_s }
    @created_records = @created_records.merge(
      result.results
      .zip(result.ids.map(&:to_i))
      .to_h
    )
    #@not_processed_ips = @not_processed_ips - result.failed_instances.map { |e| e['ip'] }
    @errors += result.failed_instances
    @queue = []
  end

  def attributes_from_row(row)
    attributes = {}
    attributes[:ip] = row[:ip]
    attributes[:description] = row[:description]
    attributes[:current_user] = @current_user
    if row[:organization].present?
      attributes[:organization_id] = Organization.where(name: row[:organization]).first.id
    else
      attributes[:organization_id] = @organization_id
    end
    attributes
  end
end
