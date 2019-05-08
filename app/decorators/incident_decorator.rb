# frozen_string_literal: true

class IncidentDecorator < SimpleDelegator
  def self.wrap(collection)
    collection.map do |obj|
      new obj
    end
  end

  def show_full_name
    "#{id} #{name} (#{created_at.strftime('%d.%m.%Y-%H:%M')})"
  end

  def show_id
    "##{id}"
  end

  def show_discovered_at
    date_or_datetime discovered_at, discovered_time
  end

  def show_started_at
    date_or_datetime started_at, started_time
  end

  def show_finished_at
    date_or_datetime finished_at, finished_time
  end

  def show_severity
    Incident.severities[severity]
  end

  def show_damage
    Incident.damages[damage]
  end

  def show_state
    Incident.states[state]
  end

  private

  def date_or_datetime(datetime_field, time_option_field)
    return '---' unless datetime_field
    if time_option_field
      datetime_field.strftime('%d.%m.%Y-%H:%M')
    else
      datetime_field.strftime('%d.%m.%Y')
    end
  end
end
