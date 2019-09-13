# frozen_string_literal: true

# = Record show helper
module ShowHelper
  # Provides method to display record attributes
  # formated as a table row.
  #
  # It assumes that bootstrap and slim used in Rails project.

  class RecordWrapper
    attr_reader :decorated#, :previous_record, :previous_decorated, :record

    def initialize(record, decorator, context)
      @record = record
      @context = context
      @decorated = decorator.new(record) if decorator
#      if record.respond_to?(:versions)
#        @previous_record = record.versions.last.reify
#        @previous_decorated = decorator.new(@previous_record) if decorator
#      end
    end

    # Display record attribute.
    # ==== Options
    # * <tt>:atribute</tt> - Specifies record attribute to display
    # * <tt>:options</tt> - Hash wich specifies:
    #  label: attribute label (default like attribute name)
    #  value: attribute value
    #
    # * <tt>:block</tt> - Specifies code to display attribute value
    #
    # ==== Examples
    #  row.show :name
    #
    #  row.show :name,
    #           label: 'User name',
    #           value: "My name is #{@user.name}"
    #
    # TODO: add block param implementation
    def show(attribute, options = {}, &block)
      options[:label] ||= @record.class
                                 .human_attribute_name(attribute.to_sym)
      block_content = if block.present?
        @context.capture(&block) || ''
      end
      options[:value] ||= block_content
      options[:value] ||= @record.send(attribute.to_sym)
      @context.render 'helpers/show_attribute',
                      attribute_label: options[:label],
                      attribute_value: options[:value]
    end
  end

  #  Display table with record attributes.
  # ==== Options
  # * <tt>:record</tt> - Specifies record whose attributes will display
  # * <tt>:decorator</tt> - Specifies decorator class for record
  # * <tt>:block</tt> - Specifies block in which attributes will display
  #
  # ==== Examples
  #  show_for(@user), decorator: UserDecorator do |row|
  #    row.show :name
  #    row.show :name, value: row.decorated.show_full_name
  #  end
  #
  #  show_for(@user) do |row|
  #    row.show :name,
  #             label: 'User name',
  #             value: "My name is #{@user.name}"
  #  end
  def show_for(record, options = {}, &block)
    record_wrapper = RecordWrapper.new(record, options.fetch(:decorator, nil), self)
    render 'helpers/show_record', record: record_wrapper, &block
  end
end
