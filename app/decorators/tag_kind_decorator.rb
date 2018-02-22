# frozen_string_literal: true

class TagKindDecorator < SimpleDelegator
  def name_with_code
    "#{code_name} (#{name}) "
  end
end
