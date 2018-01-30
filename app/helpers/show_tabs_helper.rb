# frozen_string_literal: true

module ShowTabsHelper
  Struct.new('ShowTabs', :tabs, :active_name) do
    def tab(name, link)
      active = (name == active_name)
      tabs << { active: active, link: link }
    end
  end

  def show_tabs_for(record, active_name)
    show_tabs = Struct::ShowTabs.new([], active_name)
    yield(show_tabs)
    render 'helpers/show_tabs',
           record: record,
           tabs: show_tabs.tabs
  end
end
