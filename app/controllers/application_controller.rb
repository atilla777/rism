class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  add_flash_types :danger, :success

  helper_method :current_user_session, :current_user
  before_action :authenticate?

  def index
    @q = get_model.ransack(params[:q])
    @records = @q.result
                       .order(name: :asc)
                       .page(params[:page])
  end

  def show
    @record = get_record
  end

  def new
    @record = get_model.new
  end

  def create
    @record = get_model.new(record_params)
    if @record.save
      redirect_to polymorphic_path(@record), success: t('flashes.create',
                                                        model: get_model.model_name.human)
    else
      render :new
    end
  end

  def edit
    @record = get_record
  end

  def update
    @record = get_record
    if @record.update(record_params)
      redirect_to @record, success: t('flashes.update',
                                      model: get_model.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @record = get_record
    @record.destroy
    redirect_to polymorphic_url(@record.class), success: t('flashes.destroy',
                                                           model: get_model.model_name.human)
  end
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

  private
  def get_record
    @record = get_model.find(params[:id])
  end

  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(permit_attributes)
  end
end
