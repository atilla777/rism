# frozen_string_literal

# = Records table for index page helper
module IndexHelper
  class Index
    attr_reader :h, :headers, :rows, :top_rows

    def initialize(context, records)
      @context = context
      @records = records
      @headers = []
      @rows = []
      @top_rows = []
    end

    def header(options)
      @headers << options
      @headers.map! do |h|
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

    def body
      @records.each_with_index do |record, i|
        @rows[i] ||= IndexRow.new(@context, record)
        yield(@rows[i], record)
      end
    end

    def top_row(&block)
      @top_rows << @context.capture(&block)
    end
  end

  class IndexRow
    attr_reader :context, :record, :fields, :headers

    Field = Struct.new(:value, :options)

    def initialize(context, record)
      @context = context
      @record = record
      @fields = []
    end

    def field(content = nil, options = {}, &block)
      content ||= block.present? ? @context.capture(&block) : ''
      @fields <<  Field.new(content, options)
    end
  end

  # ===Examples
  # = index_for @users do
  #   - i.header attribute: :name, sort: :desc
  #   - i.header attribute: :organization_id, sort_by: :organization_name, sort: :desc
  #   - i.header attribute: :phone, sort: :desc
  #   - i.body do | r, record |
  #     - r.field link_to(record.name, record)
  #     - r.field link_to(record.organization.name, record.organization)
  #     - r.field record.phone
  # end
  def index_for(records, options = {})
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
