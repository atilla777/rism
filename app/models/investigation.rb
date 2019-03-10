class Investigation < ApplicationRecord
  #require 'uri'
  require 'resolv'

  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Investigation::Ransackers

  INDICATOR_KINDS = {
    md5: /^[a-f0-9]{32}$/,
    sha256: /^[a-f0-9]{64}$/,
    sha512: /^[a-f0-9]{128}$/,
    email_adress: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i,
    network: Resolv::IPv4::Regex,
    url: URI.regexp
  }

  enum threat: %i[
                  other
                  network
                  email
                  process
                  account
                 ]

  attr_accessor :indicators_list

  before_validation :set_name
  after_save :set_indicators

  validates :name, length: { in: 3..100 }
  validates :feed_id, numericality: { only_integer: true }
  validates :organization_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }
  validates :threat, inclusion: { in: Investigation.threats.keys}

  belongs_to :user
  belongs_to :organization
  belongs_to :feed
  has_many :indicators, dependent: :destroy

  private

  def set_name
    return if name.present?
    self.name = InvestigationDecorator.new(self).show_threat
  end

  def set_indicators
    indicators_list.split("\n")
                   .map do |string|
                     next if string.blank?
                     create_indicator string
                   end
  end

  def create_indicator(string)
    string.strip!
     indicator_params = cast_indicator(string)
     return unless indicator_params.fetch(:ioc_kind, false)
     indicator_params.merge!(
       investigation_id: id,
       user_id: user_id,
       trust_level: :unknown,
       enrichment: {}
     )
     indicator = Indicator.new(indicator_params)
     indicator.current_user = User.find(user_id)
     indicator.save
  end

  def cast_indicator(string)
#    case string
#    when MD5
#      { ioc_kind: :md5, content: $~[0]}
#    end
    INDICATOR_KINDS.each do |kind, pattern|
      break {content: $~[0], ioc_kind: kind} if pattern =~ string
    end
  end
end
