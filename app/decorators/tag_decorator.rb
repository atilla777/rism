# frozen_string_literal: true

class TagDecorator < SimpleDelegator
  def show_full_name
    "#{tag_kind.code_name}#{rank} (#{name})"
  end

  def show_name_and_kind
    "#{tag_kind.name} - #{name}"
  end

  def show_code_name
    "#{tag_kind.code_name}#{rank}"
  end
end
