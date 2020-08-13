# frozen_string_literal: true

module User::AuthlogicConfig
  extend ActiveSupport::Concern

  PASSWD_REGEXP =/[-!\@$%^&*()_+|~=`{}\[\]:";'<>?,.\/\\]/

  included do
    acts_as_authentic do |c|
      condition_for_password = proc do
                    (password.present? || password_confirmation.present?) ||
                    (new_record? && active) ||
                    (crypted_password.blank? && active)
                  end
      condition_for_email = proc do
                    (password.present? || password_confirmation.present?) ||
                    (new_record? && active) ||
                    (crypted_password.blank? && active) ||
                    email.present?
                  end
      c.crypto_provider = Authlogic::CryptoProviders::Sha512
      c.merge_validates_uniqueness_of_email_field_options if: :active
      c.merge_validates_length_of_password_field_options minimum: 8, if: condition_for_password
      c.merge_validates_confirmation_of_password_field_options if: condition_for_password
      c.merge_validates_length_of_password_confirmation_field_options if: condition_for_password
      c.merge_validates_format_of_email_field_options(
        message: I18n.t('user_session.email_required'),
        if: condition_for_email
      )
    end

    before_save :set_activity

    validate :password, :password_complexity
  end

  private

  def password_complexity
    return if password.blank? ||
      self.password =~ /(?=.*?[A-ZА-Я])(?=.*?[a-zа-я])(?=.*?[0-9])(?=.*?#{PASSWD_REGEXP})/
    errors.add :password, I18n.t('messages.user.password_complexity_error')
  end

  def set_activity
    return unless active
    self.confirmed = true
    self.approved = true
  end
end
