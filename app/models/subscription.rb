class Subscription < ApplicationRecord
  PUBLICABLE_TYPES = %w[
    Investigation
    VulnerabilityBulletin
    Article
  ].freeze

  def self.publicable_types
   PUBLICABLE_TYPES
  end

  validates :user_id, numericality: {only_integer: true}
  validates :publicable_type, inclusion: {in: publicable_types}
  validates(
    :user_id,
    uniqueness: {scope: :publicable_type}
  )

  belongs_to :user
end
