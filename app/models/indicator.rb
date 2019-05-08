class Indicator < ApplicationRecord
  require 'resolv'

  include OrganizationAssociated
  include Linkable
  include Tagable
  include Attachable
  include Indicator::Ransackers

  CONTENT_KINDS = [
    {kind: :other, pattern: /^\s*other:\s*(.{1,500})$/, check_prefix: true},
    {kind: :network, pattern: /^\s*(#{Resolv::IPv4::Regex})\s*$/},
    {kind: :email_adress, pattern: /^\s*([\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+)\s*$/i, check_prefix: true},
    {kind: :email_theme, pattern: /^\s*email_theme:\s*(.{1,500})$/, check_prefix: true},
    {kind: :email_content, pattern: /^\s*email_content:\s*(.{1,500})$/, check_prefix: true},
    {kind: :uri, pattern: /\s*uri:\s*(#{URI.regexp})/, check_prefix: true},
    {kind: :domain, pattern: /^\s*domain:\s*((((?!-))(xn--|_{1,1})?[a-z0-9-]{0,61}[a-z0-9]{1,1}\.)*(xn--)?([a-z0-9\-]{1,61}|[a-z0-9-]{1,30}\.[a-z]{2,}))$/, check_prefix: true},
    {kind: :md5, pattern: /^\s*([a-f0-9]{32})\s*$/i},
    {kind: :sha256, pattern: /^\s*([a-f0-9]{64})\s*$/i},
    {kind: :sha512, pattern: /^\s*([a-f0-9]{128})\s*$/i},
    {kind: :filename, pattern: /^\s*filename:\s*(.{1,500})$/, check_prefix: true},
    {kind: :filesize, pattern: /^\s*filesize:\s*(.{1,500})$/, check_prefix: true},
    {kind: :process, pattern: /^\s*process:\s*(.{1,500})$/, check_prefix: true},
    {kind: :account, pattern: /^\s*account:\s*(.{1,500})$/, check_prefix: true},
  ]

  attr_accessor :indicators_list, :skip_format_validation

  enum trust_level: %i[
                       unknown
                       low
                       high
                      ]

  enum content_kind: CONTENT_KINDS.map { |i| i[:kind] }

  before_save :downcase_hashes

  validate :check_content_format, unless: :skip_format_validation

  validates :investigation_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :content_kind, inclusion: { in: Indicator.content_kinds.keys}
  validates :content, presence: true
  validates :trust_level, inclusion: { in: Indicator.trust_levels.keys}
  validates :content, uniqueness: { scope: :investigation_id }

  #serialize :enrichment, Hash

  belongs_to :investigation
  belongs_to :user
  has_one :organization, through: :investigation

  def self.human_attribute_content_kinds
    Hash[Indicator.content_kinds.map { |k,v| [v, Indicator.human_enum_name(:content_kind, k)] }]
  end

  def self.human_attribute_trust_levels
    Hash[Indicator.trust_levels.map { |k,v| [v, Indicator.human_enum_name(:trust_level, k)] }]
  end

  def self.cast_indicator(string)
    result = CONTENT_KINDS.each do |i|
      break {content: $1, content_kind: i[:kind]} if i[:pattern] =~ string
    end
    if result.is_a? Hash
      return result
    else
      return {}
    end
  end

  # TODO: translate error message
  def check_content_format
    content_kind_description = CONTENT_KINDS.find { |i| i[:kind] == content_kind.to_sym }
    content_with_prefix= if content_kind_description.fetch(:check_prefix, false)
      "#{content_kind}:#{content}"
    else
      content
    end
    casted_indicator = Indicator.cast_indicator(content_with_prefix)
    return if casted_indicator[:content_kind] == content_kind.to_sym
    errors.add(:content, :wrong_format_or_dublication)
  end

  def downcase_hashes
    return unless [:md5, :sha512, :sha256].include?(content_kind.to_sym)
    self.content = self.content.downcase
  end
end
