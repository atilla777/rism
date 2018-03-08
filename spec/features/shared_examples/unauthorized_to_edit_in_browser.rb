# frozen_string_literal: true

RSpec.shared_examples 'unauthorized to edit in browser' do
  scenario 'can`t edit record' do
    records
    visit polymorphic_path(resource_class)
    click_on(I18n.t('views.action.edit'), match: :first)

    expect(page).to have_text(I18n.t('messages.not_allowed'))
  end

  scenario 'can`t delete record', js: true do
    records
    visit polymorphic_path(resource_class)
    click_on(I18n.t('views.action.delete'), match: :first)
    confirm

    expect(page).to have_text(I18n.t('messages.not_allowed'))
  end
end
