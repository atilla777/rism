class PublicationMailer < ApplicationMailer
  add_template_helper(DateTimeHelper)

  def notify
    @current_user = params[:current_user]
    @publicable = params[:publicable_type]
      .constantize
      .find(params[:publicable_id])
    subscriptors = @publicable.subscriptors
    emails = only_allowed_for_record_subscriptors_mails(subscriptors)
    if emails.present?
      send_notify(emails)
      notifications_logs(subscriptors)
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

  def send_notify(subscriptors)
    file = @publicable.report
    attachments[file[:name]] = file[:file] if file
    mail(
      from: ENV['MAIL_FROM'],
      to: subscriptors,
      subject: t('labels.notify_subject')
    )
  end

  def notifications_logs(subscriptors)
    subscriptors.each do |user|
      NotificationsLog.create!(
        created_at: Time.now,
        user: @current_user,
        recipient: user,
        deliverable_type: @publicable.class.to_s,
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
