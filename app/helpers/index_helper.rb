module IndexHelper
  def index_for(records, attributes, &block)
    attributes.map! do | a |
      a[:label] ||= records.klass.human_attribute_name(a[:name].to_sym)
      a
    end
    render 'helpers/index_records',
      records: records,
      attributes: attributes,
      &block
  end
end
