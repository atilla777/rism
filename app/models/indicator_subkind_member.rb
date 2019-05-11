# frozen_string_literal: true

class IndicatorSubkindMember < ApplicationRecord
  belongs_to :indicator
  belongs_to :indicator_subkind

  validates :indicator_id, numericality: { only_integer: true }
  validates :indicator_subkind_id, numericality: { only_integer: true }
end
