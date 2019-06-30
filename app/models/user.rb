# frozen_string_literal: true

class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  has_paper_trail ignore: %i[password]

  validates :email, presence: true, if: proc { |r| r.active == true }
  validates :department_id,
            numericality: { only_integer: true, allow_blank: true }
  validates :department_name,
            length: { in: 1..100, allow_blank: true }
  validates :rank,
            numericality: { only_integer: true, allow_blank: true }

  before_save :set_organization_id,
              if: ->(obj) { obj.department_id.present? }

  belongs_to :department, optional: true

  has_many :incidents, dependent: :restrict_with_error

  has_many :investigation, dependent: :destroy

  has_many :indicator, dependent: :destroy

  def search_filters(model)
    SearchFilter.where(
      user_id: self.id,
      filtred_model: model.model_name.to_str
    ).or(SearchFilter.where(
        shared: true,
        filtred_model: model.model_name.to_str,
        organization_id: self.organization_id
      )
    )
  end

  def show_full_name
    name
  end

  private

  def set_organization_id
    self.organization_id = department.organization_id
  end
end
