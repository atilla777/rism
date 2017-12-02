class  VersionDecorator < SimpleDelegator
  def version_info
    result = []
    result << index + 1
    result << "id:#{id}"
    if event == 'update'
      result <<  I18n.t("navigations.version_update")
    else
      result <<  I18n.t("navigations.version_create")
    end
    result << created_at.strftime("%d.%m.%Y-%H:%m")
    result << User.find(version_author).name if version_author.present?
    result.join(' ')
  end

  def author
    User.find(whodunnit)&.name if whodunnit.present?
  end
end
