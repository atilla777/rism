# frozen_string_literal: true

class Tag < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 150 }
  validates :rank, numericality: { only_integer: true }
  validates :tag_kind_id, numericality: { only_integer: true }
  validates :name, uniqueness: { scope: :tag_kind_id }

  belongs_to :tag_kind

  has_many :tag_members, dependent: :restrict_with_error
  has_many :agreements, through: :tag_members
  has_many :incidents, through: :tag_members
  #TODO: add all tagable modeles

  validate :color, :css_hex

  def self.record_types
    Right.subject_types
  end

  def self.allowed_only_to_model(model)
    # TODO: make filter for template original record class
    return includes(:tag_kind) if model == 'RecordTemplate'
    where(tag_kinds: { record_type: model })
    .includes(:tag_kind)
  end

  def self.allowed_to_model(model)
    # TODO: make filter for template original record class
    return includes(:tag_kind) if model == 'RecordTemplate'
    where(tag_kinds: { record_type: model })
    .or(where(tag_kinds: { record_type: '' }))
    .includes(:tag_kind)
  end

  def self.allowed_to_record(record)
    Tag.allowed_to_model record.class.name
  end

  private

  # TODO: make translation
  def css_hex
    return if color =~ /^#([A-Fa-f0-9]{6}|[A-Fa-f0-9]{3})$/i
    errors.add(:color, 'must be a valid CSS hex color code')
  end
end
