RSpec.shared_examples 'feature authorized to read' do
  scenario 'can view records' do
    records
    visit polymorphic_path(resource_class)

    expect(page).to have_text(records.last.send(resource_attribute))
  end

  scenario 'can view record' do
    visit polymorphic_path(records.first)

    expect(page).to have_text(records.first.send(resource_attribute))
  end
end
