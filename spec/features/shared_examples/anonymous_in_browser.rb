# frozen_string_literal: true

RSpec.shared_examples 'anonymous in browser' do
  scenario 'can`t view records' do
    records
    visit polymorphic_path(resource_class)

    expect(page).not_to have_text(I18n.t('user_sessions.sign_in'))
    expect(page).not_to have_text(records.last.send(resource_attribute))
  end

  scenario 'can`t view record' do
    visit polymorphic_path(records.first)

    expect(page).not_to have_text(I18n.t('user_sessions.sign_in'))
    expect(page).not_to have_text(records.first.send(resource_attribute))
  end
end
