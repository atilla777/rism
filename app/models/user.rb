# frozen_string_literal: true

class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include User::DeviseConfig
  include Linkable
  include Tagable
  include Attachable
  include Rightable

  has_paper_trail(
    ignore: %i[password
               failed_login_count
               perishable_token
               login_count
               last_request_at
               current_login_at
               last_login_at
               updated_at
               persistence_token
               crypted_password
               perishable_token
               password_salt]
  )

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

  has_many :created_investigations,
           class_name: 'Investigation',
           foreign_key: :created_by_id

  has_many :updated_investigations,
           class_name: 'Investigation',
           foreign_key: :updated_by_id

  has_many :created_indicators,
           class_name: 'Indicator',
           foreign_key: :created_by_id

  has_many :updated_indicators,
           class_name: 'Indicator',
           foreign_key: :created_by_id

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
