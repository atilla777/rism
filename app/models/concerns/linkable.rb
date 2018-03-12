# frozen_string_literal: true

module Linkable
  extend ActiveSupport::Concern

  included do
    has_many :my_links, as: :first_record, dependent: :destroy
    has_many :me_links, as: :second_record, dependent: :destroy

    # records that was linked to this one
    has_many :my_linked_records, through: :my_links, foreign_key: :second_record
    # records wich this record was linked to
    has_many :me_linked_records, through: :me_links, foreign_key: :first_record

    def self.searchable_for_link_by(name)
      define_method(:main_attribute) do
        name
      end

      define_method(:show_main_attribute) do
        send(main_attribute)
      end
    end
  end
end

