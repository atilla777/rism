class Link < ApplicationRecord
  belongs_to :first_record, polymorphic: true
  belongs_to :second_record, polymorphic: true
  belongs_to :link_kind

  def self.record_types
    Right.subject_types
  end
end
