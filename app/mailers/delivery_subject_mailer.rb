class DeliverySubjectMailer < ApplicationMailer
  add_template_helper(DateTimeHelper)

  def notify
    @current_user = params[:current_user]
    @comments = params[:comments]
    @publicable = params[:publicable_type]
      .constantize
      .find(params[:publicable_id])
    recipients = @publicable.recipients
    emails = only_allowed_for_record_subscriptors_mails(recipients)
    if emails.present?
      send_notify(emails)
      notifications_logs(recipients)
    end
  end

  private

  def only_allowed_for_record_subscriptors_mails(subscriptors)
    subscriptors.each_with_object([]) do |subscriptor, memo|
      if subscriptor.admin_editor_reader? || subscriptor.can?(:read, @publicable)
        memo << subscriptor.email
      end
    end
  end

  def send_notify(recipients)
    file = @publicable.report
    attachments[file[:name]] = file[:file] if file
    mail(
      from: ENV['MAIL_FROM'],
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
        deliverable_type: @publicable.class.name,
        deliverable_id: @publicable.id
      )
    end
  rescue ActiveRecord::RecordInvalid => error
    logger = ActiveSupport::TaggedLogging.new(Logger.new("log/rism_error.log"))
    logger.tagged("NOTIFICATIONS_LOG (#{Time.now})") do
      logger.error(error)
    end
  end
end
