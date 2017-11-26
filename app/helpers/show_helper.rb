module ShowHelper
  def show_for(record, &block)
    options = {}
    options[:versions] = record.class.paper_trail.enabled?
    render 'helpers/show_record', record: record, options: options, &block
  end

  def show(record, attribute, options = {})
    options[:label] ||= record.class.human_attribute_name(attribute.to_sym)
    options[:value] ||= record.send(attribute.to_sym)
    render 'helpers/show_attribute',
            record: record,
            attribute_label: options[:label],
            attribute_value: options[:value]
  end
end
