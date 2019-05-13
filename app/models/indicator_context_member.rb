# frozen_string_literal: true

class IndicatorContextMember < ApplicationRecord
  belongs_to :indicator
  belongs_to :indicator_context

  validates :indicator_id, numericality: { only_integer: true }
  validates :indicator_context_id, numericality: { only_integer: true }
end
