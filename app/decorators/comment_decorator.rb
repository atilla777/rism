# frozen_string_literal: true

class CommentDecorator < SimpleDelegator
  include DateTimeHelper

  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_header
    "#{user.name} #{show_date_time(created_at)}"
  end
end
