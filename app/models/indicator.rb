class Indicator < ApplicationRecord
  include OrganizationAssociated
  include Indicator::Ransackers

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
end
