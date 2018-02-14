module UIAutocompliteHelper
  def fill_in_autocomplete(input_selector, item_text)
    fill_in input_selector, with: item_text
    page.execute_script %{ $('##{input_selector}').trigger('focus') }
    page.execute_script %{ $('##{input_selector}').trigger('keydown') }
    expect(page).to have_selector('ul.ui-autocomplete li.ui-menu-item')
    selector = %{ ul.ui-autocomplete li.ui-menu-item:contains("#{item_text}") }
    page.execute_script %{ $('#{selector}').trigger('mouseenter').click() }
  end
end

RSpec.configure do |config|
  config.include UIAutocompliteHelper, type: :feature
end
