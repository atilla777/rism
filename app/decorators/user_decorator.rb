class  UserDecorator < SimpleDelegator
  def contact
    result = []
    result << name if name.present?
    result << job if job.present?
    result << "#{I18n.t('labels.phone')} #{phone}" if phone.present?
    result.join(', ')
  end

  def full_job
    result = []
    result << job if job.present?
    result << department.name if department_id.present?
    result.join(', ')
  end
end
