class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :danger, :success

  helper_method :current_user_session, :current_user
  before_action :authenticate?

  protected
#  def handle_unverified_request
#    # raise an exception
#    #fail ActionController::InvalidAuthenticityToken
#    # or destroy session, redirect
#    if current_user_session
#      current_user_session.destroy
#    end
#    redirect_to root_url
#  end

  private
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

#  def user_not_authorized
#    flash[:danger] = t('messages.not_allowed')
#    redirect_back(fallback_location: root_path) #(request.referrer || root_path)
#  end
end
