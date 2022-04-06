# frozen_string_literal: true

class TaskDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_name_with_id
      "#{id} - #{name}"
  end


  def show_parent_with_status_and_id
    return '' unless parent
      "##{parent.id} #{parent.name} - #{parent.task_status.name}"
  end

  def show_name_with_status_and_id
      "##{id} #{name} - #{task_status.name}"
  end
  
  def show_task_tags
    task_tags.join(' ')
  end
end
