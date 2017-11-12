module IndexHelper
  class Index
    attr_reader :h, :headers, :rows, :top_rows

    def initialize(c, records)
      @c = c
      @records = records
      @headers = []
      @rows = []
      @top_rows = []
    end

    def header(options)
      @headers << options
      @headers.map! do | h |
        if h[:attribute]
          h[:label] ||= @records.klass
                                .human_attribute_name(h[:attribute].to_sym)
          h[:sort_by] ||= h[:attribute]
        else
          h[:label] ||= ''
        end
        h
      end
    end

    def body &block
      @records.each_with_index do | record, i |
        @rows[i] ||= IndexRow.new(@c, record)
        yield(@rows[i], record)
      end
    end

    def top_row &block
      @top_rows << @c.capture(&block)
    end
  end

  class IndexRow
    attr_reader :c, :record, :fields, :headers

    Field = Struct.new(:value, :options)

    def initialize(c, record)
      @c = c
      @record = record
      @fields = []
    end

    def field(content = nil, options = {}, &block)
      if content.present?
        @fields << Field.new(content, options)
      elsif block.present?
        @fields << Field.new(@c.capture(&block), options)
      else
        @fields << Field.new('', options)
      end
    end
  end

  def index_for(records, options = {}, &block)
    options[:actions] = options.fetch(:actions, true)
    index = Index.new(self, records)
    yield(index)

    render 'helpers/index',
      headers: index.headers,
      rows: index.rows,
      top_rows: index.top_rows,
      options: options
  end
end
