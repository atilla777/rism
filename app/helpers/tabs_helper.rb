# frozen_string_literal: true

module TabsHelper
  Struct.new('Tabs', :tabs, :admin_editor, :models) do
    def add(name, link, model = '', external_link = false, &label)
      if model.present?
        return unless admin_editor || models.include?(model)
      end
      tabs << {
        name: name,
        link: link,
        label:  label,
        external_link: external_link
      }
    end
  end

  # Create bootstrap 3 tab menu to use with
  # tabs_panes helper
  # ==== Attributes
  # * +active_tab+ - Current active tab name (symbol)
  # * +default_tab+ - Default active tab name (symbol)
  # * +from_external_page+ - Current active tab from another page (true or false)
  # ==== Examples
  # = tabs :users, :main_info, true do |t|
  #   - t.add :main_info, polymorphic_path(user, active_tab: :main_info) do
  #     = user.model_name.human(count: 2)
  #   - t.add :user_groups, user_groups_path(user) do
  #     = user_groups.model_name.human(count: 2)
  def tabs(active_tab, default_tab, from_external_page = false)
    active_tab = if active_tab.present?
                    {active_tab.to_sym => ' active'}
                  else
                    {default_tab => ' active'}
                  end
    tabs = Struct::Tabs.new(
      [],
      current_user_admin_editor_reader?,
      current_user_models
    )
    yield(tabs)
    render(
     'helpers/tabs',
      tabs: tabs.tabs,
      active_tab: active_tab,
      from_external_page: from_external_page
    )
  end
end
