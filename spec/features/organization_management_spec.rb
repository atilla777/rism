require 'rails_helper'

RSpec.feature 'organization management', type: :feature do
  background do
    parent = create(:organization)
    create(:organization,
           name: 'OrganizationX',
           parent_id: parent.id)
    login(role: :reader,
          allowed_organization_id: parent.id,
          allowed_model: 'Organization')
  end

  scenario 'reader can view index', js: true do
    visit organizations_path

    expect(page).to have_text('OrganizationX')
  end
end
