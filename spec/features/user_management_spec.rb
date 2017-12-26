require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  given!(:organization) { create(:organization) }
  given!(:user) { create(:user_with_right,
                        allowed_action: :read,
                        allowed_organization_id: organization.id,
                        allowed_models: ['Organization',
                                         'User']) }
  given!(:users) { create_list(:user, 3,
                              organization_id: organization.id) }

  background { login(user) }

  after(:each) { logout }

  scenario 'reader can view records', js: true do
    visit users_path

    expect(page).to have_text(users.last.name)
  end

  scenario 'reader can view record', js: true  do
    visit users_path(users.first)

    expect(page).to have_text(users.first.name)
  end

  scenario 'reader can`t edit record', js: true do
    visit users_path
    click_on(I18n.t('views.action.edit'), match: :first)

    expect(page).to have_text(I18n.t('messages.not_allowed'))
  end

  scenario 'reader can`t delete record', js: true do
    visit users_path
    click_on(I18n.t('views.action.delete'), match: :first)
    page.accept_confirm

    expect(page).to have_text(I18n.t('messages.not_allowed'))
  end
end
