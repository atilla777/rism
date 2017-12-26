require 'rails_helper'

RSpec.feature 'Organization management', type: :feature do
  given!(:parent) { create(:organization) }
  given!(:children) { create_list(:organization, 3,
                           parent_id: parent.id) }
  given!(:user) { create(:user_with_right,
                        allowed_action: :read,
                        allowed_organization_id: parent.id,
                        allowed_models: ['Organization']) }

  background { login(user) }

  after(:each) { logout }

  scenario 'reader can view records', js: true do
    visit organizations_path

    expect(page).to have_text(children.last.name)
  end

  scenario 'reader can view record', js: true do
    visit organizations_path(children.first)

    expect(page).to have_text(children.first.name)
  end

  scenario 'reader can`t edit record', js: true do
    visit organizations_path
    click_on(I18n.t('views.action.edit'), match: :first)

    expect(page).to have_text(I18n.t('messages.not_allowed'))
  end

  scenario 'reader can`t delete record', js: true do
    visit organizations_path
    click_on(I18n.t('views.action.delete'), match: :first)
    page.accept_confirm

    expect(page).to have_text(I18n.t('messages.not_allowed'))
    expect(page).to have_text(children.first.name)
  end
end
