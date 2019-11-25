# frozen_string_literal: true

module Enrichmentable
  extend ActiveSupport::Concern

  included do
    has_many :enrichments, as: :enrichmentable, dependent: :delete_all
  end
end
