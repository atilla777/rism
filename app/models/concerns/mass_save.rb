# frozen_string_literal: true

module MassSave
  extend ActiveSupport::Concern

  MASS_SAVE_LIMIT = 20

  included do
    def self.mass_save(records, options = {})
      import(
        records,
        validate: true,
        batch_size: options[:mass_save_limit] || self.mass_save_limit,
        on_duplicate_key_ignore: options[:on_duplicate_key_ignore] || true,
        returning: options[:returned_field]
      )
    end

    def self.mass_save_limit
      MASS_SAVE_LIMIT
    end
  end
end
