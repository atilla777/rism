# frozen_string_literal: true

class RightDecorator < SimpleDelegator
  def show_second_record_type
    subject_types[subject_type]
  end
end
