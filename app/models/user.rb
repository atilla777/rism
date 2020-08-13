# frozen_string_literal: true

class User < ApplicationRecord
  include OrganizationMember
  include User::HasRole
  include AuthlogicConfig
  include Linkable
  include Tagable
  include Attachable
  include Rightable
  include Recipientable

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
               api_token
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
           foreign_key: :created_by_id,
           dependent: :restrict_with_error

  has_many :updated_investigations,
           class_name: 'Investigation',
           foreign_key: :updated_by_id,
           dependent: :restrict_with_error

  has_many :created_indicators,
           class_name: 'Indicator',
           foreign_key: :created_by_id,
           dependent: :restrict_with_error

  has_many :updated_indicators,
           class_name: 'Indicator',
           foreign_key: :updated_by_id,
           dependent: :restrict_with_error

  has_many :created_vulnerabilities,
           class_name: 'Vulnerability',
           foreign_key: :created_by_id,
           dependent: :restrict_with_error

  has_many :updated_vulnerabilities,
           class_name: 'Vulnerability',
           foreign_key: :updated_by_id,
           dependent: :restrict_with_error

  has_many :processed_vulnerabilities,
           class_name: 'Vulnerability',
           foreign_key: :processed_by_id,
           dependent: :restrict_with_error

  has_many :search_filters, dependent: :delete_all

  has_many :readable_logs, dependent: :delete_all
  has_many :readable, through: :readable_logs

  has_many :record_templates

  has_many :notifications_logs, dependent: :delete_all
  has_many :notifications,
           class_name: 'NotificationsLog',
           foreign_key: :recipient_id,
           dependent: :delete_all

  has_many :user_actions, dependent: :delete_all

  has_many :subscriptions, dependent: :delete_all

  def search_filters_for(model)
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

  def self.api_user(token)
    user = find_by(api_token: token)
    return false unless user
    return user if user.api_user?
    false
  end

  private

  def set_organization_id
    self.organization_id = department.organization_id
  end
end
