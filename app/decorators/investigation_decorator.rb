# frozen_string_literal: true
class InvestigationDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end
end
