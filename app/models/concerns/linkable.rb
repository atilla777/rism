# frozen_string_literal: true

module Linkable
  extend ActiveSupport::Concern

  included do
    #has_many :my_links, class_name: 'Link', as: :first_record, dependent: :destroy
    # and the same (aliase to my links) to use with fields_for:
    has_many :links, as: :first_record, dependent: :destroy

    has_many :me_links, class_name: 'Link', as: :second_record, dependent: :destroy

    # records that was linked to this one
    has_many :my_linked_records, through: :links, foreign_key: :second_record
    # records wich this record was linked to
    #has_many :me_linked_records, through: :me_links, source: :first_record, source_type: '?', foreign_key: :first_record

    # TODO: use or delete
    has_many(
      :me_linked_incidents,
      as: :second_record,
      through: :me_links,
      source: :first_record,
      source_type: 'Incident'
    )
  end
end
