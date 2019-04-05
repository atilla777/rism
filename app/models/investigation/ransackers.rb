# frozen_string_literal: true

module Investigation::Ransackers
  extend ActiveSupport::Concern
  include RansackerDatetimeCast

  included do
    ransacker :created_at_reverse_str do
      RansackerDatetimeCast.datetime_field_to_text_search 'investigations', 'created_at', :reverse
    end
  end
end
