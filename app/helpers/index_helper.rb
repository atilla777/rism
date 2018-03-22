# frozen_string_literal: true

# = Table with records for index page
# Create index page table
# with records, sort, filter and RUD (CRUD whithout Create) actions.
#
# It assumes that bootstrap, slim and ransack in the Rails project are used.
module IndexHelper
  # Generate table with records
  # ==== Attributes
  # * +records+ - ActiveRelation instance (displayed records)
  # * +options+ - custom table visible elements (view Options in section below)
  # * +block+   - code to work with instance of Index class
  # ==== Options
  # +:actions+ - show or not show RUD action for each record
  # (default is true)
  # ==== Examples
  #  = index_for @users do |table|
  #    - table.header attribute: :name, sort: :desc
  #    - table.header attribute: :phone, sort: :desc
  #    - table.header attribute: :organization_id, sort_by: :organization_name, sort: :desc
  #    - table.body do |r, record|
  #      - r.field link_to(record.name, record)
  #      - r.field record.phone
  #      - r.field link_to(record.organization.name, record.organization)
  def index_for(records, options = {})
    options.slice(:actions)
    options[:actions] = options.fetch(:actions, true)
    index = Index.new(self, records)
    yield(index)

    render 'helpers/index',
           headers: index.headers,
           rows: index.rows,
           top_rows: index.top_rows,
           options: options
  end

  # == Represent table with records
  # Instance of that class is transfered as param
  # to #index_for method block
  class Index
    attr_reader :h, :headers, :rows, :top_rows

    def initialize(context, records)
      @context = context
      @records = records
      @headers = []
      @rows = []
      @top_rows = []
    end

    # Set table header
    # ==== Options
    # * +:attribute+ - record attribute (symbol) that will
    # be displayed in table column
    # (can be ommited, for example in column that not associated with
    # record attribute)
    # * +:label+     - displayed column caption
    # (default is a human attribute name, if :attribute is set)
    # * +:sort+      - sort column direction (:asc or :desc),
    # column will be sortable only if :sort direction is set
    # * +:sort_by+   - sort column field (default is like an :attribute),
    # can be any field in attribute of ActiveRelation record,
    # fields of associated model id also supported
    # (this function is delivered by ransack)
    # ==== Examples
    #  = index_for @users do |table|
    #    - table.header / empty column header
    #    - table.header attribute: :name / not sortable column with user names
    #    - table.header attribute: :phone, sort: :desc / sortable column with users phones
    #    - table.header attribute: :organization_id, sort_by: :organization_name, sort: :desc
    #    / sortable column with associated table (organizations) column
    def header(options)
      if options[:attribute]
        options[:label] ||= @records
                            .klass
                            .human_attribute_name(options[:attribute].to_sym)
        options[:sort_by] ||= options[:attribute]
      else
        options[:label] ||= ''
      end
      @headers << options.slice(:attribute, :label, :sort_by, :sort)
    end

    # Add custom top row to the table
    # ==== Attributes
    # *block* - slim code for top row
    # ==== Examples
    #  = index_for @users do |table|
    #    - table.header attribute: :name
    #    - table.top_row do
    #      tr
    #        td
    #          some text
    #    - table.body do |row, record|
    #      - row.field record
    def top_row(&block)
      @top_rows << @context.capture(&block)
    end

    # Set table body
    # ==== Attributes
    # * +block+ - block to work with table row,
    # In that block two parameters are available -
    # row (instance of a IndexRow class)
    # and record (instance of ActiveRelation class)
    # ==== Examples
    #  = index_for @users do |table|
    #    - table.header attribute: :name
    #    - table.body do | row, record |
    #      - row.field record
    def body
      # TODO: replace uniq
      @records.to_a.uniq.each do |record|
        row = IndexRow.new(@context, record)
        @rows << row
        yield(row, record)
      end
    end
  end

  # Represent row in the index page table
  # Instance of that class is transfered as param
  # to block in #body method of Index class instance
  class IndexRow
    attr_reader :context, :record, :fields, :headers

    Field = Struct.new(:value, :options)

    def initialize(context, record)
      @context = context
      @record = record
      @fields = []
    end

    # Set row column (grid table) content (value)
    # ==== Attributes
    # * +content+ - text to display in the grid (default is blank - ''),
    # such text can be created by helper (link_to, for example)
    # * +options+ - customize grid view (see in Options section)
    # * +block+   - blcok with slim code wich represent grid content
    # ====Options
    # * +:fit+ - if set to true grid will collapse to smallest size
    # (default is false)
    # ====Examples
    #  = index_for @users do |table|
    #    - table.header attribute: :name
    #    - table.header attribute: :phone
    #    - table.header attribute: :organization_id
    #    - table.header attribute: :job
    #    - table.header
    #    - table.body do | row, record |
    #      - row.field "some text #{record.name}"
    #      - row.field record.phone, fit: true
    #      - row.field link_to record.organization, record.organization.name
    #      - row.field do
    #        span.text-success
    #          = record.job
    #      - row.field
    def field(content = nil, options = {}, &block)
      options = options.slice(:fit)
      content ||= block.present? ? @context.capture(&block) : ''
      @fields <<  Field.new(content, options)
    end
  end
end
