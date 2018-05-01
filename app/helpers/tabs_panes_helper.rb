# frozen_string_literal: true

module TabsPanesHelper
  Struct.new('TabPanes', :panes) do
    def add(name, &content)
      panes << {name: name, content: content}
    end
  end

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
