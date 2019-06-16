# frozen_string_literal: true

class DeliverySubjectDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_processed
    processed ? I18n.t('labels.yes_label') : I18n.t('labels.no_label')
  end
end
