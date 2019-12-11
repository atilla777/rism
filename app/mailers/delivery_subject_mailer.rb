class DeliverySubjectMailer < ApplicationMailer
  add_template_helper(DateTimeHelper)

  def notify
    @current_user = params[:current_user]
    @deliverable = params[:delivery_subject_type]
      .constantize
      .find(params[:delivery_subject_id])
    recipients = @deliverable.recipients
    send_notify(recipients.pluck(:email))
    notifications_logs(recipients)
  end

  private

  def send_notify(recipients)
    file = @deliverable.report
    attachments[file[:name]] = file[:file] if file
    mail(
      to: recipients,
      subject: t('labels.notify_subject')
    )
  end

  def notifications_logs(recipients)
    recipients.each do |user|
      NotificationsLog.create(
        created_at: Time.now,
        user: @current_user,
        recipient: user,
        deliverable_type: @deliverable.class.name,
        deliverable_id: @deliverable.id
      )
    end
  end
end
