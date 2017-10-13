module IndexHelper
  class IndexRow
    attr_reader :record, :fields, :headers

    def initialize(record)
      @record = record
      @fields = []
    end

    def field(value = nil, *headers, &block)
      if value.present?
        @fields << value
      elsif block.present?
        @fields << yield
      else
        @fields << ''
      end
    end
  end

  def index_for(records, *headers, &block)
    headers.map! do | h |
      h[:label] ||= records.klass
                           .human_attribute_name(h[:attribute].to_sym)
      h
    end
    rows = []

    records.each_with_index do | record, i |
      rows[i] ||= IndexRow.new(record)
      rows[i] ||= IndexRow.new(record)
      yield(rows[i], record)
    end

    render 'helpers/index',
      headers: headers,
      rows: rows
  end
end
