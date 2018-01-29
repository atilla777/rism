# frozen_string_literal: true

# = Page caption helper
module CaptionHelper
  # Provides method for converting object to text,
  # that can be used as show or index page caption
  # (title).
  #
  # It assumes that bootstrap and slim used in Rails project.
  #
  # Method can take three first argument types:
  # * one record (model instance)
  # * several records (ActiveRelation instance)
  # * text string
  #
  # You can customize output (set HTML class, id e.t.c) by
  # set options hash as second argument .
  #
  # ==== Options
  # * <tt>:tag</tt> - Specifies html tag (default is h3)
  # * <tt>:id</tt> - Specifies html id
  # * <tt>:class</tt> - Specifies html class (default is text-info)
  #
  # ==== Examples
  #  caption(@user)        # => <h3 class='text-primary'>User</h3>
  #
  #  caption(@users)       # => <h3 class='text-primary'>Users</h3>
  #
  #  caption('Text')       # => <h3 class='text-primary'>Text</h3>
  #
  #  caption(@record, tag: :span, class: 'text-primary', id: 'caption1')
  #  # => <span class='text-primary' id='caption1'> Record </span>
  def caption(record_or_records_or_text, options = {})
    caption = case record_or_records_or_text
              when ActiveRecord::Relation
                record_or_records_or_text.klass
                                         .model_name
                                         .human(count: 2)
              when ActiveRecord::Base
                record_or_records_or_text.class
                                         .model_name
                                         .human
              when String
                record_or_records_or_text
              else
                raise(
                  ArgumentError,
                  'It should be a one record, several records or text string.'
                )
              end
    options = set_options(options)
    render('helpers/caption', caption: caption,
                              tag: options)
  end

  private

  def set_options(options)
    options[:tag] ||= 'h3'
    options[:class] ||= 'text-info'
    options.slice(:tag, :class, :id)
  end
end
