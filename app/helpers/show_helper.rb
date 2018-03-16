# frozen_string_literal: true

# = Record show helper
module ShowHelper
  # Provides method to display record attributes
  # formated as a table row.
  #
  # It assumes that bootstrap and slim used in Rails project.

  class RecordWrapper
    def initialize(record, context)
      @record = record
      @context = context
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
      options[:value] ||= @context.capture(&block) if block.present?
      options[:value] ||= @record.send(attribute.to_sym)

      @context.render 'helpers/show_attribute',
                      attribute_label: options[:label],
                      attribute_value: options[:value]
    end
  end

  #  Display table with record attributes.
  # ==== Options
  # * <tt>:record</tt> - Specifies record whose attributes will display
  # * <tt>:block</tt> - Specifies block in which attributes will display
  #
  # ==== Examples
  #  show_for(@user) do |row|
  #    row.show :name
  #  end
  #
  #  show_for(@user) do |row|
  #    row.show :name,
  #             label: 'User name',
  #             value: "My name is #{@user.name}"
  #  end
  def show_for(record, &block)
    record_wrapper = RecordWrapper.new(record, self)
    render 'helpers/show_record', record: record_wrapper, &block
  end
end
