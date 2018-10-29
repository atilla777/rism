# frozen_string_literal: true

module Legalitiable
  extend ActiveSupport::Concern

  included do
    enum legality: %i[illegal unknown legal no_sense]

    validates :legality, inclusion: { in: legalities.keys}
  end

  COLORS = ['#228B22', '#DAA520', '#DC143C'].freeze

  class_methods do
    def legality_to_color code
      COLORS.reverse[code]
    end

    def human_attribute_legalities
      Hash[self.legalities.map { |k,v| [v, self.human_enum_name(:legality, k)] }]
    end
  end

  def legality_color
    self.class.legality_to_color self.class.legalities[legality]
  end
end
