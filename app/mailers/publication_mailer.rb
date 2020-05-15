class PublicationMailer < ApplicationMailer
  add_template_helper(DateTimeHelper)

  def notify
    @current_user = params[:user]
    @publicable = params[:publicable_type]
      .constantize
      .find(params[:publicable_id])
    subscriptors = @publicable.subscriptors
    if subscriptors.present?
      send_notify(subscriptors.pluck(:email))
      notifications_logs(subscriptors)
    end
  end

  private

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
