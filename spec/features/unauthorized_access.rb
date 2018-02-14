# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'unauthorized access' do
  given(:resource) { :agreement_kind }
  given(:resource_class) { AgreementKind }
  given(:records) do
    create_list(resource, 3)
  end

  shared_examples 'not authorized to access in feature' do
  end

  background { login(user) }

  after { logout }

  context 'when ordinar reader' do
    given(:user) do
      create(
        :user_with_right,
        allowed_action: :read,
        allowed_models: ['Organization', OrganizationKind]
      )
    end

    scenario 'can`t view records' do
      records
      visit polymorphic_path(resource_class)

      expect(page).to have_text(I18n.t('messages.not_allowed'))
    end

    scenario 'can`t view record' do
      visit polymorphic_path(records.first)

      expect(page).to have_text(I18n.t('messages.not_allowed'))
    end
  end
end
