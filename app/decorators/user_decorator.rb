class  UserDecorator < SimpleDelegator
  def contact
    result = []
    result << name if name.present?
    result << job if job.present?
    result << phone if phone.present?
    result.join(', ')
  end
end
