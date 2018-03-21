# frozen_string_literal: true

class Link < ApplicationRecord
  def self.record_types
    Right.subject_types
  end

  attr_accessor :nested

  validates :link_kind_id, numericality: { only_integer: true }
  validates :first_record_id, numericality: { only_integer: true }, unless: proc { |f| f&.nested }
  validates :first_record_type, inclusion: { in: record_types.keys }
  validates :second_record_id, numericality: { only_integer: true }
  validates :second_record_type, inclusion: { in: record_types.keys }
  validates(
    :first_record_type,
    uniqueness: {
      scope: %i[
        link_kind_id
        first_record_id
        second_record_type
        second_record_id
      ]
    }
  )

  belongs_to :first_record, polymorphic: true, optional: true
  belongs_to :second_record, polymorphic: true

  belongs_to :link_kind
end
