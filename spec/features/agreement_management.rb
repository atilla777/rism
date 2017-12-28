require 'rails_helper'

RSpec.feature 'Agreement management', type: :feature do
  given!(:organization) { create(:organization) }
  given!(:not_allowed_organization) { create(:organization) }
  given!(:user) { create(:user_with_right,
                        allowed_action: :read,
                        allowed_organization_id: organization.id,
                        allowed_models: ['Organization',
                                         'Agreement']) }
  given!(:agreements) { create_list(:agreement, 3,
                                    organization_id: organization.id) }
  given!(:not_allowed_agreement) { create(:agreement,
                                    organization_id: not_allowed_organization.id) }

  background { login(user) }

  after(:each) { logout }

  scenario 'reader can view records', js: true do
    visit agreements_path

    expect(page).to have_text(agreements.last.prop)
  end

  scenario 'reader can`t view not allowed records', js: true do
    visit agreements_path

    expect(page).not_to have_text(not_allowed_agreement.prop)
  end

  scenario 'reader can view record', js: true do
    visit agreements_path(agreements.first)

    expect(page).to have_text(agreements.first.prop)
  end

  scenario 'reader can`t view not allowed record', js: true do
    visit agreements_path(not_allowed_agreement)

    #expect(page).to have_text(I18n.t('messages.not_allowed'))
    expect(page).not_to have_text(not_allowed_agreement.prop)
  end

  scenario 'reader can`t edit record', js: true do
    visit agreements_path
    click_on(I18n.t('views.action.edit'), match: :first)

    expect(page).to have_text(I18n.t('messages.not_allowed'))
  end

  scenario 'reader can`t delete record', js: true do
    visit agreements_path
    click_on(I18n.t('views.action.delete'), match: :first)
    page.accept_confirm

    expect(page).to have_text(I18n.t('messages.not_allowed'))
    expect(page).to have_text(agreements.first.prop)
  end
end
