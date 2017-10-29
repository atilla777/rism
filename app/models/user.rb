class User < ApplicationRecord
  include OrganizationMember

  acts_as_authentic do |c|
    c.crypto_provider = Authlogic::CryptoProviders::Sha512
    c.merge_validates_format_of_email_field_options message: I18n.t('user_session.email_required')
    c.merge_validates_uniqueness_of_email_field_options if: :active
    condition = proc do
      (password.present? || password_confirmation.present?) ||
      (new_record? && active) ||
      (crypted_password.blank? && active)
    end
    c.merge_validates_length_of_password_field_options minimum: 6, if: condition
    c.merge_validates_confirmation_of_password_field_options if: condition
    c.merge_validates_length_of_password_confirmation_field_options if: condition
    c.merge_validates_format_of_email_field_options if: condition
  end

  before_save :set_activity
  #before_destroy :protect_admin

  validates :email, presence: true, if: Proc.new { | r | r.active == true }

  belongs_to :organization
  has_many :role_members
  has_many :roles, through: :role_members

  def admin?
    roles.any?{ | role | role.id == 1 }
  end

  def admin_editor?
    roles.any?{ | role | (1..2).include? role.id }
  end

  def admin_editor_reader?
    roles.any?{ | role | (1..3).include? role.id }
  end

  def can?(action, record_or_model)
    level = Right.action_to_level(action)
    case record_or_model
    when ActiveRecord::Base
      return can_action_record?(level, record_or_model.class.model_name.to_s, record_or_model)
    else Class
      return can_action_model?(level, record_or_model)
    end
  end

  private
  def can_action_model?(level, model)
    Right.where(role_id: roles)
         .where(subject_type: subject_type(model))
         .where('rights.level <= ?', level)
         .present?
  end

  def can_action_record?(level, model, record)
    Right.where(role_id: roles)
         .where(organization_id: record.top_organizations)
         .where(subject_type: model)
         .where('subject_id = :record_id OR subject_id IS NULL', record_id: record.id)
         .where('rights.level <= ?', level)
         .present?

  end

  def subject_type(record_or_model)
    case record_or_model
    when ActiveRecord::Base
      record_or_model.class.model_name.to_s
    else Class
      record_or_model.to_s
    end
  end

  def set_activity
    return unless active
    self.confirmed = true
    self.approved = true
  end
end
