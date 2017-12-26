require 'rails_helper'

RSpec.feature 'User management', type: :feature do
  given!(:parent) { create(:organization) }
  given!(:children) { create(:organization,
                           parent_id: parent.id) }
  given!(:user) { create(:user_with_right,
                        allowed_action: :read,
                        allowed_organization_id: parent.id,
                        allowed_model: 'User') }
  given!(:users) { create_list(:user, 3,
                          organization_id: children.id) }

  background { login(user) }

  after(:each) { logout }

  scenario 'reader can view index' do
    visit users_path

    expect(page).to have_text(users.last.name)
  end

  scenario 'reader can view show' do
    visit users_path(users.first)

    expect(page).to have_text(users.first.name)
  end
end
