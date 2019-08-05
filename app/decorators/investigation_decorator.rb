# frozen_string_literal: true

class InvestigationDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_creator
    creator&.name || ''
  end

  def show_updater
    updater&.name || ''
  end
end
