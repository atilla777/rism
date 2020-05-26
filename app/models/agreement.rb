# frozen_string_literal: true

class Agreement < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  ransacker :beginning do
    Arel.sql("to_char(beginning, 'YYYY.MM.DD')")
  end

  has_paper_trail

  validate :organization_not_contrcator
  validates :beginning, presence: true
  validates :prop, length: {minimum: 1, maximum: 100}
  validates :beginning, uniqueness: {scope: [:prop, :organization_id]}
  validates :agreement_kind_id, numericality: {only_integer: true, allow_blank: true}
  validates :contractor_id, numericality: {only_integer: true}

  belongs_to :contractor, class_name: 'Organization'
  belongs_to :agreement_kind, optional: true

  # for use with RecordTemplate, Link and
  # in autocomplite (inside controller)
  def show_full_name
    I18n.t(
      'labels.agreement.full_name',
      prop: prop,
      beginning: beginning,
      organization: organization.name,
      contractor: contractor.name
    )
  end

  private

  # TODO: make translation
  def organization_not_contrcator
    return unless organization_id == contractor_id
    errors.add(:organization_id, 'can`t be as contractor')
    errors.add(:contractor_id, 'can`t be as organization')
  end
end
