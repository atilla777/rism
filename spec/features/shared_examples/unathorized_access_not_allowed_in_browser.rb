# frozen_string_literal: true

RSpec.shared_examples 'unauthorized access not allowed in browser' do
  scenario 'can`t view not allowed records' do
    not_allowed_record
    visit polymorphic_path(resource_class)

    expect(page).not_to have_text(not_allowed_record.send(resource_attribute))
  end

  scenario 'can`t view record' do
    visit polymorphic_path(not_allowed_record)

    expect(page).not_to have_text(not_allowed_record.send(resource_attribute))
  end
end
