# frozen_string-literal: true

class UserDecorator < SimpleDelegator
  def original
    self.__getobj__
  end

  def class
    self.__getobj__.class
  end

  def show_active
    active ? I18n.t('labels.user.active') : I18n.t('labels.user.not_active')
  end

  def show_api_user
    api_user ? I18n.t('labels.yes_label'): I18n.t('labels.no_label')
  end

  def contact
    result = []
    result << name if name.present?
    result << job if job.present?
    result << "#{I18n.t('labels.user.phone')} #{phone}" if phone.present?
    result.join(', ')
  end

  def full_job
    result = []
    if job.present?
      result << job
      dep_name = department&.name || department_name
      result << dep_name if dep_name.present?
    end
    result.join(', ')
  end

  def dep_name
    department&.name || department_name || ''
  end
end
