require 'rails_helper'

RSpec.feature 'session_management', type: :feature do
  given(:organization) { create(:organization) }
  given(:admin) { create(:user,
                        :skip_validation,
                        name: 'Admin',
                        email: 'admin@rism.io',
                        active: true,
                        organization_id: organization.id) }
  given(:user) { create(:user,
                        :skip_validation,
                        name: 'User',
                        email: 'user@rism.io',
                        active: true,
                        organization_id: organization.id) }
  given(:contact) { create(:user,
                        :skip_validation,
                        name: 'Contact',
                        email: 'contact@rism.io',
                        active: false,
                        organization_id: organization.id) }
  given(:admin_role) { create(:role, :admin) }
  given(:role) { create(:role, :custom_role) }
  given(:admin_to_admin_role) { create(:role_member,
                                    role_id: admin_role.id,
                                    user_id: admin.id) }
  given(:user_to_custom_role) { create(:role_member,
                                    role_id: role.id,
                                    user_id: user.id) }
  given(:custom_role_right) do
    create(:right, :manage,
      organization_id: organization.id,
      role_id: role.id,
      subject_type: 'Organization')
  end

  background do
    organization
    user
    admin
    admin_role
    role
    admin_to_admin_role
    user_to_custom_role
    custom_role_right
  end

  scenario 'contact can`t login' do
    visit sign_in_path
    fill_in 'email', with: contact.email
    fill_in I18n.t('user_sessions.password'), with: 'password'
    click_button I18n.t('user_sessions.sign_in')

    expect(page).to have_text(I18n.t('user_sessions.sign_in_error'))
  end

  scenario 'admin can login' do
    visit sign_in_path
    fill_in 'email', with: admin.email
    fill_in I18n.t('user_sessions.password'), with: 'password'
    click_button I18n.t('user_sessions.sign_in')

    expect(page).to have_text(I18n.t('user_sessions.welcome'))
  end

  scenario 'admin can logout' do
    visit sign_in_path
    fill_in 'email', with: admin.email
    fill_in I18n.t('user_sessions.password'), with: 'password'
    click_button I18n.t('user_sessions.sign_in')
    click_on I18n.t('user_sessions.sign_out')

    expect(page).to have_text(I18n.t('user_sessions.goodbay'))
  end

  scenario 'user can login' do
    visit sign_in_path
    fill_in 'email', with: user.email
    fill_in I18n.t('user_sessions.password'), with: 'password'
    click_button I18n.t('user_sessions.sign_in')

    expect(page).to have_text(I18n.t('user_sessions.welcome'))
  end
end
