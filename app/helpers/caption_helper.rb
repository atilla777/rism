# frozen_string_literal: true

# = Page caption helper
# Convert object to text,
# that can be used as show or index page caption
# (title over a table with records or record attributes).
#
# It assumes that bootstrap and slim is used in the Rails project.
module CaptionHelper
  CAPTION_TAG = 'h3'
  CAPTION_CLASS = 'caption text-info'

  # Generate page caption
  #
  # ==== Attributes
  # Method can take three first argument types:
  # * +record+   - one record (model instance)
  # * +records+  - several records (ActiveRelation instance)
  # * +text+   - text string
  #
  # ==== Options
  # You can customize output (set HTML tag, class, id) by
  # set options hash as second argument.
  #
  # * +:tag+   - Specifies html tag (default is <h3>)
  # * +:id+    - Specifies html id
  # * +:class+  - Specifies html class (default is text-info)
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
    options.slice(:tag, :class, :id)
    options[:tag] ||= CAPTION_TAG
    options[:class] ||= CAPTION_CLASS
    caption = case record_or_records_or_text
              when ActiveRecord::Relation
                record_or_records_or_text.klass
                                         .model_name
                                         .human(count: 2)
              when ActiveRecord::Base
                result = record_or_records_or_text.class
                                                  .model_name
                                                  .human
                if record_or_records_or_text.respond_to?(:name)
                  result += ": #{record_or_records_or_text.name}"
                end
                result
              when String
                record_or_records_or_text
              else
                raise(
                  ArgumentError,
                  'It should be a one record, several records or text string.'
                )
              end
    render('helpers/caption', caption: caption,
                              tag: options)
  end
end
