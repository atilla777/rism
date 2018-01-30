# frozen_string_literal: true

module IndexNewButtonHelper
  def index_new_button(records_or_model, options = {})
    caption = case records_or_model
              when ActiveRecord::Relation
                model = records_or_model.klass
                records_or_model.klass.model_name.human
              when Class
                model = records_or_model
                records_or_model.model_name.human
              end
    options[:label] ||= t('helpers.submit.create', model: caption)
    render 'helpers/index_new_button',
           model: model,
           label: options[:label],
           options: options
  end
end
