# frozen_string_literal: true

class UserActionDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_user_name
    return 'anonymouse' if user.blank?
    user.name
  end

  def show_organization_name
    return '' if organization.blank?
    organization.name
  end

  def show_event
    event ? event : ''
  end

  def show_record_model
    record_model ? record_model : ''
  end

  def show_record_id
    record_id ? record_id : ''
  end
end
