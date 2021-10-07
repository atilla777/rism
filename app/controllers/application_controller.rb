# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pundit

  # TODO: move to controllers with versioned models
  before_action :set_paper_trail_whodunnit

  after_action :verify_authorized, unless: -> { controller_name == 'pictures' || 'attachment_file' }

  protect_from_forgery with: :exception

  add_flash_types :danger, :success

  helper_method(
    :current_user_session,
    :current_user,
    :current_user_models,
    :current_user_admin_editor_reader?
  )

  before_action :authenticate?

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  after_action :log_user_action

  private

  def authenticate?
    return if current_user
    if request.xhr?
      return render json: {success: false, errors: ['Sign in is required.']}
    else
      session[:go_to] = request.original_url
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

  def current_user_models
    return @current_user_models if defined?(@current_user_models)
    @current_user_models = current_user.allowed_models
  end

  def current_user_admin_editor_reader?
    current_user.admin_editor_reader?
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

  def log_user_action
    #  Comment string below if you want log RA (rism agent) actions
    return if controller_name == 'ra_api'

    activity = UserAction.new
    activity.created_at = DateTime.now
    activity.current_user = current_user
    activity.user = current_user
    activity.browser = request.env['HTTP_USER_AGENT']
    activity.ip = request.env['HTTP_X_FORWARDED_FOR'] || request.env['REMOTE_ADDR'] || '127.0.0.1'
    activity.controller = controller_name
    activity.action = action_name
    activity.comment = ''
    if @record
      activity.record_model = if @record.class.respond_to?(:model_name)
                                @record.class.model_name
                              else # if record is delegator instance
                                @record&.__getobj__&.class&.model_name
                              end
    end
    activity.record_id = @record.id if @record
    if params.dig('user_session', 'password')
      if @user_session&.errors&.present?
        activity.comment += @user_session.errors.full_messages.join(', ')
        activity.event = 101 # login failed
      else
        activity.event = 100 # login success
      end
      parameters = params
      activity.params  = parameters
      activity.params['user_session']['password'] = '*'
    else
      if @record&.errors&.present?
        activity.comment += @record.errors.full_messages.join(', ')
        activity.event = 201 # record save errors
      end
      activity.params = params.except('file', 'upload', 'attached_file')
    end
    if controller_name == 'ra_api'
      activity.params = nil
    end
    activity.skip_current_user_check = true
    activity.save!
  rescue ActiveRecord::RecordInvalid
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("USER_ACTION (#{Time.now}):") do
      logger.error("user action can`t be saved - #{record.errors.full_messages}")
    end
  end
end
