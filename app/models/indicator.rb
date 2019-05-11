class Indicator < ApplicationRecord
  # require 'resolv' #{Resolv::IPv4::Regex}

  include OrganizationAssociated
  include Linkable
  include Tagable
  include Attachable
  include Indicator::Ransackers
  include Indicator::Kinds

  attr_accessor :indicators_list, :skip_format_validation
  attr_accessor :indicator_subkind_ids

  enum trust_level: %i[
                       unknown
                       low
                       high
                      ]

  enum content_kind: CONTENT_KINDS.map { |i| i[:kind] }

  before_save :downcase_hashes
  after_save :set_indicator_subkind_member

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

  has_many :indicator_subkind_members
  has_many :indicator_subkinds, through: :indicator_subkind_members

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

  def set_indicator_subkind_member
    SetIndicatorSubkindsService.call(id, indicator_subkind_ids)
  end
end
