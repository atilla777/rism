# frozen_string_literal: true

module TabsHelper
  Struct.new('Tabs', :tabs) do
    def add(name, link, external_link = false, &label)
      tabs << {
        name: name,
        link: link,
        label: label,
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
  # = tabs :users, :main_info, true
  def tabs(active_tab, default_tab, from_external_page = false)
    active_tab = if active_tab.present?
                    {active_tab.to_sym => ' active'}
                  else
                    {default_tab => ' active'}
                  end
    tabs = Struct::Tabs.new([])
    yield(tabs)
    render(
     'helpers/tabs',
      tabs: tabs.tabs,
      active_tab: active_tab,
      from_external_page: from_external_page
    )
  end
end
