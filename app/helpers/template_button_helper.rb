module TemplateButtonHelper
  def template_button(model, options = {})
    templates = RecordTemplate.allowed_for_model(model.name)
    Reports.names_where(
      templates: templates
    )
    return if templates.blank?
    render(
      'helpers/template_button',
      templates: templates,
      model: model,
      options: options
    )
  end
end
