# frozen_string_literal: true

class TagDecorator < SimpleDelegator
  def show_full_name
    "#{tag_kind.code_name}#{rank} (#{name})"
  end
end
