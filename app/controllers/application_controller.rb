class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  helper_method :current_user_session, :current_user
  before_filter :authenticate?

  private
#  def protocol_action(note = '')
#      @protocol = UserProtocol.new
#      @protocol.description = note
#      @protocol.user = current_user
#      @protocol.ip_address = request.env['REMOTE_ADDR']
#      @protocol.controller = controller_name
#      @protocol.action = action_name
#      @protocol.save
#  end

  def authenticate?
      unless current_user
        redirect_to :sign_in
      end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.user
  end

  def user_not_authorized
    flash[:danger] = t('messages.not_allowed')
    redirect_to(request.referrer || root_path)
  end
end
