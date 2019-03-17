class Indicator < ApplicationRecord
  require 'resolv'

  include OrganizationAssociated
  include Linkable
  include Tagable
  include Attachable
  include Indicator::Ransackers

  INDICATOR_KINDS = {
    md5: /^[a-f0-9]{32}$/,
    sha256: /^[a-f0-9]{64}$/,
    sha512: /^[a-f0-9]{128}$/,
    email_adress: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    network: Resolv::IPv4::Regex,
    url: URI.regexp
  }

  attr_accessor :indicators_list

  enum trust_level: %i[
                       unknown
                       low
                       high
                      ]
  enum ioc_kind: %i[
                    other
                    network
                    email_adress
                    email_theme
                    email_content
                    url
                    domain
                    md5
                    sha256
                    sha512
                    filename
                    filesize
                    process
                    account
                   ]

  validate :check_content_format

  validates :investigation_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :ioc_kind, inclusion: { in: Indicator.ioc_kinds.keys}
  validates :content, presence: true
  validates :trust_level, inclusion: { in: Indicator.trust_levels.keys}

  #serialize :enrichment, Hash

  belongs_to :investigation
  belongs_to :user
  has_one :organization, through: :investigation

  def self.human_attribute_ioc_kinds
    Hash[Indicator.ioc_kinds.map { |k,v| [v, Indicator.human_enum_name(:ioc_kind, k)] }]
  end

  def self.human_attribute_trust_levels
    Hash[Indicator.trust_levels.map { |k,v| [v, Indicator.human_enum_name(:trust_level, k)] }]
  end

  def self.cast_indicator(string)
    INDICATOR_KINDS.each do |kind, pattern|
      break {content: $~[0], ioc_kind: kind} if pattern =~ string
    end
  end

  # TODO: translate error message
  def check_content_format
    return if Indicator.cast_indicator(content)[:ioc_kind] == ioc_kind.to_sym
    errors.add(:content, 'wrong format')
  end
end
