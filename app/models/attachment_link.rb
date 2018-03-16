# frozen_string_literal: true

class AttachmentLink < ApplicationRecord
  LINKABLE_MODELS = [Agreement].freeze

  def self.linkable_models
    LINKABLE_MODELS
  end

  attr_accessor :nested

  validates :record_type, presence: true
  validates :record_id, numericality: { only_integer: true }
  validates :attachment_id, numericality: { only_integer: true }, unless: proc { |f| f.nested }

  belongs_to :attachment
  belongs_to :record, polymorphic: true

  after_destroy :remove_attachment

  private

  def remove_attachment
    links = AttachmentLink.where(attachment_id: attachment_id)
    attachment.destroy if links.blank?
  end
end
