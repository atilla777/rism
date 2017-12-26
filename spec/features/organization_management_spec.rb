require 'rails_helper'

RSpec.feature 'organization management', type: :feature do
  given!(:parent) { create(:organization) }
  given!(:children) { create_list(:organization, 3,
                           parent_id: parent.id) }
  given!(:user) { create(:user_with_right,
                        allowed_action: :read,
                        allowed_organization_id: parent.id,
                        allowed_model: 'Organization') }

  background { login(user) }

  after(:each) { logout }

  scenario 'reader can view index', js: true do
    visit organizations_path

    expect(page).to have_text(children.last.name)
  end

  scenario 'reader can view show', js: true do
    visit organizations_path(children.first)

    expect(page).to have_text(children.first.name)
  end
end
