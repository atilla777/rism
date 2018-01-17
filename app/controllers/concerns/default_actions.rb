# default actions/methods for all models (tables)
# which not belongs to organization
# (organization model included)
module DefaultActions
  extend ActiveSupport::Concern

  included do
    before_action :set_edit_previous_page, only: [:new, :edit]
    before_action :set_show_previous_page, only: [:index]
  end

  def index
    authorize get_model
    scope = policy_scope(get_model)
    @q = scope.ransack(params[:q])
    @q.sorts = default_filter if @q.sorts.empty?
    @records = @q.result
                 .page(params[:page])
  end

  def show
    @record = get_record
    authorize @record
  end

  def new
    authorize get_model
    @record = get_model.new
  end

  def create
    authorize get_model
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
    authorize @record
  end

  def update
    @record = get_record
    authorize @record
    if @record.update(record_params)
      redirect_to @record, success: t('flashes.update',
        model: get_model.model_name.human)
    else
      render :edit
    end
  end

  def destroy
    @record = get_record
    authorize @record
    @record.destroy
    redirect_to polymorphic_url(@record.class), success: t('flashes.destroy',
      model: get_model.model_name.human)
  end

  private
  def set_show_previous_page
    session[:show_return_to] = request.original_url
  end

  def set_edit_previous_page
    session[:return_to] = request.referer
  end

  def get_record
    if params[:version_id].present?
      version = PaperTrail::Version.find(params[:version_id])
      @record =  version.event == 'create' ? get_model.find(params[:id]) : version.reify
    else
      @record = get_model.find(params[:id])
    end
    @record
  end

  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(policy(get_model).permitted_attributes)
  end

  def default_filter
    'name asc'
  end
end
