RSpec.shared_examples 'manage organization record' do
#  def fill_in_autocomplete(id, value)
#     page.execute_script("document.getElementById('#{id}').setAttribute('value', '#{value}');")
#  end
  def fill_in_autocomplete(input_selector, item_text)
    fill_in input_selector, with: item_text

    page.execute_script %Q{ $('##{input_selector}').trigger('focus') }
    page.execute_script %Q{ $('##{input_selector}').trigger('keydown') }
   # selector = %Q{ul.ui-autocomplete li.ui-menu-item a:contains("#{item_text}")}
    #save_and_open_page
    page.should have_selector('ul.ui-autocomplete li.ui-menu-item')
    selector = %{ul.ui-autocomplete li.ui-menu-item:contains("#{item_text}")}
    page.execute_script %Q{ $('#{selector}').trigger('mouseenter').click() }
#    page.execute_script %Q{ $('##{input_selector}').trigger("focus") }
#    page.execute_script %Q{ $('##{input_selector}').trigger("keydown") }
#    # Set up a selector, wait for it to appear on the page, then use it.
#    item_selector = "ul.ui-autocomplete li.ui-menu-item a:contains('#{item_text}')"
#    page.should have_selector item_selector
#    page.execute_script %Q{ $("#{item_selector}").trigger("mouseenter").trigger("click"); }
  end
given(:organization) { create(:organization) }
  given(:not_allowed_organization) { create(:organization) }
  given(:records) do
    create_list(resource, 3, organization_id: organization.id)
  end
  given(:not_allowed_record) do
    create(resource, organization_id: not_allowed_organization.id)
  end

  context 'when anonymous' do
    it_behaves_like 'feature anonymous'
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
          allowed_models: ['Organization', resource_class.name ]
        )
      end

      it_behaves_like 'feature authorized to read'

      it_behaves_like 'feature unauthorized to edit'

      it_behaves_like 'feature unauthorized access not allowed'
    end

    context 'when editor' do
      given(:user) do
        create(
          :user_with_right,
          allowed_action: :edit,
          allowed_organization_id: organization.id,
          allowed_models: ['Organization', resource_class.name ]
        )
      end

      it_behaves_like 'feature authorized to read'

      it_behaves_like 'feature authorized to edit'

      it_behaves_like 'feature unauthorized access not allowed'
    end
  end
end
