# frozen_string_literal: true

class RightDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_second_record_type
    subject_types[subject_type]
  end

  def show_organization_id
    organization_id || ''
  end

  def show_subject_id
    subject_id || ''
  end
end
