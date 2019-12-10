class DeliverySubjectMailer < ApplicationMailer
  def notify
    @deliverable = params[:delivery_subject_type]
      .constantize
      .find(params[:delivery_subject_id])

    recipients = @deliverable.delivery_lists.each_with_object([]) do |delivery_list, mail_list|
      mail_list << delivery_list.users.pluck(:email)
    end

    file = @deliverable.report

    attachments[file[:name]] = file[:file] if file

    mail(
      to: recipients,
      subject: t('labels.notify_subject')
    )
  end
end
