# frozen_string_literal: true

module ColorIconHelper
  def color_icon(color, icon = 'star')
    render(
      'helpers/color_icon',
      color: color,
      icon: icon
    )
  end
end
