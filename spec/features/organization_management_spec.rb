# frozen_string_literal: true

require 'rails_helper'

RSpec.feature 'Organization management', type: :feature do
  def fill_in_new
    fill_in 'organization[name]', with: resource_attribute_value
    fill_in_autocomplete('parent', organization.name[0, 3])
  end

  given(:resource) { :organization }
  given(:resource_class) { Organization }
  given(:resource_attribute) { :name }
  given(:resource_attribute_value) { 'MMM JSC' }
  given(:organization) { create :organization }
  given(:not_allowed_organization) { create(:organization) }
  given(:records) do
    create_list(resource, 3, parent_id: organization.id)
  end
  given(:not_allowed_record) do
    create(resource, parent_id: not_allowed_organization.id)
  end

  context 'when anonymous' do
    it_behaves_like 'anonymous in browser'
  end

  describe 'role members' do
    background { login(user) }

    after { logout }

    context 'when reader' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :read,
          allowed_organization_id: organization.id,
          allowed_models: ['Organization', resource_class.name]
        )
      end

      it_behaves_like 'authorized to read in browser'

      it_behaves_like 'unauthorized to edit in browser'

      it_behaves_like 'unauthorized access not allowed in browser'
    end

    context 'when editor' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :edit,
          allowed_organization_id: organization.id,
          allowed_models: ['Organization', resource_class.name]
        )
      end

      it_behaves_like 'authorized to read in browser'

      it_behaves_like 'authorized to edit in browser'

      it_behaves_like 'unauthorized access not allowed in browser'
    end
  end
end
