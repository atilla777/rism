class User < ApplicationRecord
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

  private
  def set_activity
    return unless active
    self.confirmed = true
    self.approved = true
  end
end
