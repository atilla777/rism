# frozen_string_literal: true

class HostService < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Legalitiable
  include HostService::Ransackers
  include Rightable

  PROTOCOLS = %w[tcp udp]

  has_paper_trail

  before_save :set_status_changet_at

  validates :host_id, numericality: { only_integer: true }
  validates :name, length: { in: 3..200, allow_blank: true }
  validates :port,
            uniqueness: { scope: [:protocol, :host_id] },
            allow_blank: true
  validates :port, inclusion: { in: 0..65535 }
  validates :protocol, presence: true
  validates :host_service_status_prop, length: {minimum: 3, maximum: 100, allow_blank: true}

  belongs_to :host
  belongs_to :host_service_status, optional: true

  def self.protocols
    PROTOCOLS
  end

  # TODO: add filter for allowed for job organizations
  def self.legality(ip, port, protocol, state)
    host_service = self.where(
      port: port, protocol: protocol
    )
    .joins(:host)
    .where(hosts: {ip: ip})
    .first
    if state.to_sym == :open
      return :unknown if host_service.blank?
      host_service.legality
    else
      :no_sense
    end
  end

  def show_full_name
    "#{name} #{port} #{protocol}"
  end

  def self.records_scope
      HostService.select('host_services.*')
                 .select('scan_results.state')
                 .select('scan_results.id AS scan_result_id')
                 .joins(HostService.join_host)
                 .joins(HostService.join_scan_result)
  end

  def self.join_host
    <<~SQL
      LEFT JOIN hosts
        ON host_services.host_id = hosts.id
    SQL
  end

  def self.join_scan_result
    <<~SQL
      LEFT JOIN scan_results
      ON scan_results.ip = hosts.ip
      AND scan_results.port = host_services.port
      AND scan_results.protocol = host_services.protocol
      AND scan_results.id IN
      (SELECT
       scan_results.id
       FROM scan_results
        INNER JOIN (
          SELECT
            scan_results.ip,
            MAX(scan_results.job_start)
            AS max_time
          FROM scan_results
          GROUP BY scan_results.ip
        )m
        ON scan_results.ip = m.ip
        AND scan_results.job_start = m.max_time
      )
    SQL
  end

  private

  def set_status_changet_at
    return unless self.host_service_status_id_changed?
    self.host_service_status_changed_at = Time.now
  end
end
