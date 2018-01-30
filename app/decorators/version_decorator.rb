# frozen_string_literal: true

class VersionDecorator < SimpleDelegator
  include DateTimeHelper

  def version_info
    result = []
    result << index + 1
    result << "id:#{id}"
    result << show_event
    result << show_date_time(created_at)
    result << User.find(version_author).name if version_author.present?
    result.join(' ')
  end

  def author
    User.find(whodunnit)&.name if whodunnit.present?
  end

  def show_event
    if event == 'update'
      I18n.t('labels.version.updated')
    else
      I18n.t('labels.version.created')
    end
  end
end
