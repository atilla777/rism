# frozen_string_literal: true

class IndicatorSubkind < ApplicationRecord
  has_many :indicator_subkind_members, dependent: :delete_all
  has_many :indicators, through: :indicator_subkind_members

  validates :name, length: { minimum: 3, maximum: 200 }
  validates :name, uniqueness: true

  validates :codename, length: { minimum: 1, maximum: 100 }
  validates :codename, uniqueness: true

  before_save :set_indicators_kinds

  private

  def set_indicators_kinds
    indicators_kinds.compact!
      .map! {|indicators_kind| indicators_kind.to_i}
  end
end
