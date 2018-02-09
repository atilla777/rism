RSpec.shared_examples 'feature authorized to edit' do
  scenario 'can create record', js: true do
    visit polymorphic_path(resource_class)
    click_on I18n.t('helpers.submit.create', model: resource_class.model_name.human)
    fill_in_new
    click_button I18n.t('helpers.submit.save')

    expect(page).to have_text(resource_attribute_value)
  end

  scenario 'can edit record' do
    visit polymorphic_path(records.first)
    click_on I18n.t('views.action.edit')
    fill_in "#{resource}[#{resource_attribute.to_s}]", with: resource_attribute_value
    save_and_open_page
    click_button I18n.t('helpers.submit.save')

    #expect(page).to_not have_css('.alert-danger')
    expect(page).to have_text(resource_attribute_value)
  end

  scenario 'can delete record', js: true do
    records
    visit polymorphic_path(resource_class)
    click_on(I18n.t('views.action.delete'), match: :first)
    page.accept_confirm

    expect(page).to_not have_text(I18n.t('messages.not_allowed'))
  end
end
