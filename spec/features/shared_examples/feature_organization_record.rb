RSpec.shared_examples 'feature organization record' do
  given(:organization) { create(:organization) }
  given(:not_allowed_organization) { create(:organization) }
  given(:records) do
    create_list(resource, 3, organization_id: organization.id)
  end
  given(:not_allowed_record) do
    create(resource, organization_id: not_allowed_organization.id)
  end

  context 'when anonymous' do
    scenario 'can`t view records' do
      records
      visit polymorphic_path(resource_class)

      expect(page).to_not have_text(I18n.t('user_sessions.sign_in'))
      expect(page).to_not have_text(records.last.send(resource_attribute))
    end

    scenario 'can`t view record' do
      visit polymorphic_path(records.first)

      expect(page).to_not have_text(I18n.t('user_sessions.sign_in'))
      expect(page).to_not have_text(records.first.send(resource_attribute))
    end
  end

  context 'when authorized' do
    given(:user) do
      create(
        :user_with_right,
        allowed_action: :read,
        allowed_organization_id: organization.id,
        allowed_models: ['Organization', resource_class.name ]
      )
    end

    background { login(user) }

    after { logout }

    scenario 'reader can view records' do
      records
      visit polymorphic_path(resource_class)

      expect(page).to have_text(records.last.send(resource_attribute))
    end

    scenario 'reader can`t view not allowed records' do
      not_allowed_record
      visit polymorphic_path(resource_class)

      expect(page).not_to have_text(not_allowed_record.send(resource_attribute))
    end

    scenario 'reader can view record' do
      visit polymorphic_path(records.first)

      expect(page).to have_text(records.first.send(resource_attribute))
    end

    scenario 'reader can`t view not allowed record' do
      visit polymorphic_path(not_allowed_record)

      expect(page).not_to have_text(not_allowed_record.send(resource_attribute))
    end

    scenario 'reader can`t edit record' do
      records
      visit polymorphic_path(resource_class)
      click_on(I18n.t('views.action.edit'), match: :first)

      expect(page).to have_text(I18n.t('messages.not_allowed'))
    end

    scenario 'reader can`t delete record', js: true do
      records
      visit polymorphic_path(resource_class)
      click_on(I18n.t('views.action.delete'), match: :first)
      page.accept_confirm

      expect(page).to have_text(I18n.t('messages.not_allowed'))
    end
  end
end
