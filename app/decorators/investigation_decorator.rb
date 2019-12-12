# frozen_string_literal: true

class InvestigationDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def original_class
    __getobj__.class
  end

  def show_creator
    creator&.name || ''
  end

  def show_updater
    updater&.name || ''
  end


  def show_feed_codename
    feed_codename || ''
  end
end
