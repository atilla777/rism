# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  # TODO: move to controllers with versioned models
  before_action :set_paper_trail_whodunnit

  after_action :verify_authorized, unless: -> { controller_name == 'pictures' || 'attachment_file' }

  protect_from_forgery with: :exception

  add_flash_types :danger, :success

  helper_method :current_user_session, :current_user

  before_action :authenticate?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
#  protected

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

#  def ssl_configured?
#    !Rails.env.development?
#  end

  def authenticate?
    return if current_user
    if request.xhr?
      return render json: {success: false, errors: ['Sign in is required.']}
    else
      redirect_to :sign_in unless current_user
    end
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session&.user
  end

  def user_not_authorized
    if request.xhr?
      return render json: {success: false, errors: ['Authorization is required.']}
    else
      flash[:danger] = t('messages.not_allowed')
      if @current_user.has_any_role?
        redirect_back(fallback_location: root_path)
      else
        redirect_to :no_roles
      end
    end
  end
end
