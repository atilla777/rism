module IndexNewButtonHelper
  def index_new_button(records, options = {})
    options[:label] ||= t('helpers.submit.create',
                model: records.klass.model_name.human)
    model = records.klass
    render 'helpers/index_new_button',
      model: model,
      label: options[:label],
      options: options
  end
end
