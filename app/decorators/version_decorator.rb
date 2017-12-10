class  VersionDecorator < SimpleDelegator
  include DateTimeHelper

  def version_info
    result = []
    result << index + 1
    result << "id:#{id}"
    if event == 'update'
      result <<  I18n.t("labels.version.updated")
    else
      result <<  I18n.t("labels.version.created")
    end
    result << show_date_time(created_at)
    result << User.find(version_author).name if version_author.present?
    result.join(' ')
  end

  def author
    User.find(whodunnit)&.name if whodunnit.present?
  end
end
