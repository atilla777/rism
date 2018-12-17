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
  # +:actions+ - show or not show Edit/Delete action for each record
  # +:fit+ - make table column fit (collapse th and td to minimum size,
  # default is false)
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
    options.slice(:actions, :decorator)
    options[:actions] = options.fetch(:actions, true)
    index = Index.new(self, records)
    yield(index)
    if options[:decorator].present?
      records = options[:decorator].send(:wrap, index.records)
    else
      records = index.records
    end

    render 'helpers/index',
           headers: index.headers,
           top_rows: index.top_rows,
           records: records,
           field_handlers: index.field_handlers,
           options: options
  end

  # == Represent table with records
  # Instance of that class is transfered as param
  # to #index_for method block
  class Index
    attr_reader :headers, :top_rows, :records, :field_handlers

    def initialize(context, records)
      @context = context
      @headers = []
      @top_rows = []
      @records = records
      @field_handlers = []
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
    # * +:sort_array+   - used to sort by several fields,
    # array formt is in ransack documentation
    # * +:fit+       - column fit ( true or false, default is false)
    # ==== Examples
    #  = index_for @users do |table|
    #    - table.header fit: true / fit empty column header
    #    - table.header attribute: :name / not sortable column with user names
    #    - table.header attribute: :phone, sort: :desc / sortable column with users phones
    #    - table.header attribute: :organization_id, sort_by: :organization_name, sort: :desc
    #    - table.header attribute: :start, sort_by: :start, sort_array: [:start, 'finish desc']
    #    / sortable column with associated table (organizations) column
    def header(options = {})
      if options[:attribute]
        options[:label] ||= @records
                            .klass
                            .human_attribute_name(options[:attribute].to_sym)
        options[:sort_by] ||= options[:attribute]
      else
        options[:label] ||= ''
      end
      @headers << options.slice(:attribute, :label, :sort_by, :sort, :sort_array, :fit)
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

    # Set row column (grid table) content (value)
    # ==== Attributes
    # * +block+   - blcok with slim code wich represent grid content
    # * +options+ - customize grid view (see in Options section)
    # ====Examples
    #  = index_for @users do |table|
    #    - table.header attribute: :name
    #    - table.header attribute: :job
    #    - table.field { |user| user.name }
    #    - table.field do |user|
    #        span.text-success
    #          = user.job
    def field(&block)
      @field_handlers << block
    end
  end
end
