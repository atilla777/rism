class AttachmentLink < ApplicationRecord
  LINKABLE_MODELS = [Agreement].freeze

  validates :record_type, presence: true
  validates :record_id, numericality: { only_integer: true }
  validates :attachment_id, numericality: { only_integer: true }

  belongs_to :record, polymorphic: true
  belongs_to :attachment

  after_destroy :remove_attachment

  def self.linkable_models
    LINKABLE_MODELS
  end

  private
  def remove_attachment
    links = AttachmentLink.where(attachment_id: attachment_id)
    attachment.destroy unless links.present?
  end
end
