# frozen_string_literal: true

class IndicatorContext < ApplicationRecord
  validates :name, length: { minimum: 3, maximum: 200 }
  validates :name, uniqueness: true

  validates :codename, length: { minimum: 1, maximum: 100 }
  validates :codename, uniqueness: true

  before_save :set_indicators_formats

  has_many :indicator_context_members, dependent: :delete_all
  has_many :indicators, through: :indicator_context_members

  private

  def set_indicators_formats
    indicators_formats.select!(&:present?)
  end
end
