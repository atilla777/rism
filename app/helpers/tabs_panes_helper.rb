# frozen_string_literal: true

module TabsPanesHelper
  Struct.new('TabPanes', :panes) do
    def add(name, &content)
      panes << {name: name, content: content}
    end
  end
  #
  # Create bootstrap 3 panes menu to use with
  # tabs helper
  # ==== Attributes
  # * +active_pane+ - Current active pane name (symbol = active_tab name)
  # * +default_pane+ - Default active pane name (symbol = default_tab name)
  # ==== Examples
  # = tabs_panes :main_info, :main_info do |panes|
  #   - pane.add :main_info do
  #     = render 'show', user: @user
  #   - pane.add :user_groups do
  #     = render 'user_groups/index', user: @user

  def tabs_panes(active_pane, default_pane)
    tab_panes = Struct::TabPanes.new([])
    yield(tab_panes)
    active_pane = if active_pane.present?
                    {active_pane.to_sym => ' active'}
                  else
                    {default_pane => ' active'}
                  end
    render(
     'helpers/tabs_panes',
      panes: tab_panes.panes,
      active_pane: active_pane
    )
  end
end
