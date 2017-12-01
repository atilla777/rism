class  VersionDecorator < SimpleDelegator
  def last_version_info
    result = []
    result << I18n.t('navigations.current_version')
    if created_at == updated_at
      result <<  I18n.t("navigations.version_create")
    else
      result <<  I18n.t("navigations.version_update")
    end
    result << updated_at.strftime("%d.%m.%Y-%H:%m")
    result.join(' ')
  end

  def version_info
    result = []
    result << index
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
