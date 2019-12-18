# frozen_string_literal: true

module MenuLiHelper
  def menu_li(models:, controllers: nil, action: nil, role: nil, html_class: nil, &block)
    return '' unless current_user_admin_editor_reader? ||
      models_overlap_user_models?(models)

    result_class = []
    result_class << html_class

    action = if action
               action_name == action
              else
                true
             end

    controllers = if controllers
                    Array(controllers)
                  else
                    Array(models).map { |m| m.underscore.downcase.pluralize }
                  end

    if controllers.include?(controller_name) && action
      result_class << 'active'
    end

    options = {}
    options[:role] = role
    options[:result_class] = result_class.join(' ')

    render(
      'helpers/menu_li',
      options: options,
      content: capture(&block)
    )
  end

  def models_overlap_user_models?(models)
    Array(models).any? do |model|
      current_user_models.include?(model)
    end
  end
end
