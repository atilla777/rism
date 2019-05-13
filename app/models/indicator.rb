class Indicator < ApplicationRecord
  include OrganizationAssociated
  include Linkable
  include Tagable
  include Attachable
  include Indicator::Ransackers
  include Indicator::Formats

  attr_accessor :indicators_list, :skip_format_validation
  attr_accessor :indicator_subkind_ids

  enum trust_level: %i[
                       unknown
                       low
                       high
                      ]

  enum content_format: CONTENT_FORMATS.map { |i| i[:format] }

  before_save :downcase_hashes
  after_save :set_indicator_subkind_member

  validate :check_content_format, unless: :skip_format_validation

  validates :investigation_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :content_format, inclusion: { in: Indicator.content_formats.keys}
  validates :content, presence: true
  validates :trust_level, inclusion: { in: Indicator.trust_levels.keys}
  validates :content, uniqueness: { scope: :investigation_id }

  #serialize :enrichment, Hash

  belongs_to :investigation
  belongs_to :user
  has_one :organization, through: :investigation

  has_many :indicator_subkind_members
  has_many :indicator_subkinds, through: :indicator_subkind_members

  def self.human_attribute_content_formats
    new_hash = Indicator.content_formats.map do |k,v|
      [v, Indicator.human_enum_name(:content_format, k)]
    end
    Hash[new_hash]
  end

  def self.human_attribute_trust_levels
    Hash[Indicator.trust_levels.map { |k,v| [v, Indicator.human_enum_name(:trust_level, k)] }]
  end

  def self.cast_indicator(string)
    result = CONTENT_FORMATS.each do |i|
      break {content: $1, content_format: i[:format]} if i[:pattern] =~ string
    end
    if result.is_a? Hash
      return result
    else
      return {}
    end
  end

  # TODO: translate error message
  def check_content_format
    content_format_description = CONTENT_FORMATS.find do |i|
      i[:format] == content_format.to_sym
    end
    content_with_prefix= if content_format_description.fetch(:check_prefix, false)
      "#{content_format}:#{content}"
    else
      content
    end
    casted_indicator = Indicator.cast_indicator(content_with_prefix)
    return if casted_indicator[:content_format] == content_format.to_sym
    errors.add(:content, :wrong_format_or_dublication)
  end

  def downcase_hashes
    return unless [:md5, :sha512, :sha256].include?(content_format.to_sym)
    self.content = self.content.downcase
  end

  def set_indicator_subkind_member
    SetIndicatorSubkindsService.call(id, indicator_subkind_ids)
  end
end
