class DeliverySubjectMailer < ApplicationMailer
  add_template_helper(DateTimeHelper)

  def notify
    @current_user = params[:current_user]
    @comments = params[:comments]
    @deliverable = params[:deliverable_type]
      .constantize
      .find(params[:deliverable_id])
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
      NotificationsLog.create!(
        created_at: Time.now,
        user: @current_user,
        recipient: user,
        deliverable_type: @deliverable.class.name,
        deliverable_id: @deliverable.id
      )
    end
  rescue ActiveRecord::RecordInvalid => error
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("NOTIFICATIONS_LOG (#{Time.now})") do
      logger.error(error)
    end
  end
end
