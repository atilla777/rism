module IndexHelper
  class Index
    attr_reader :headers, :rows

    def initialize(records)
      @records = records
      @headers = []
      @rows = []
    end

    def header(options)
      @headers << options
      @headers.map! do | h |
        h[:label] ||= @records.klass
                              .human_attribute_name(h[:attribute].to_sym)
        h[:sort_by] ||= h[:attribute]
        h
      end
    end

    def body &block
      @records.each_with_index do | record, i |
        @rows[i] ||= IndexRow.new(record)
        yield(@rows[i], record)
      end
    end
  end

  class IndexRow
    attr_reader :record, :fields, :headers

    def initialize(record)
      @record = record
      @fields = []
    end

    def field(value = nil, &block)
      if value.present?
        @fields << value
      elsif block.present?
        @fields << yield
      else
        @fields << ''
      end
    end
  end

  def index_for(records, &block)
    index = Index.new(records)
    yield(index)

    render 'helpers/index',
      headers: index.headers,
      rows: index.rows
  end
end
