# default actions/methods for all models (tables)
# which belongs to organization
# (organization model excluded)
module Organizatable
  extend ActiveSupport::Concern

  included do
    before_action :set_edit_previous_page, only: [:new, :edit]
    before_action :set_show_previous_page, only: [:index]
  end

  def index
    authorize get_model
    @organization = get_organization
    if @organization.id.present?
      scope = filter_for_organization
    else
      scope = get_model
    end
    scope = policy_scope(scope)
    @q = scope.ransack(params[:q])

    @q.sorts = default_sort if @q.sorts.empty?
    @records = @q.result
                 .includes(default_includes)
                 .page(params[:page])
    if params[:organization_id].present? || params[:q] && params[:q][:organization_id_eq].present?
      render 'index'
    else
      render 'application/index'
    end
  end

  def show
    @record = get_record
    authorize @record
    @organization = get_organization
  end

  def new
    authorize get_model
    @record = get_model.new
    @organization = get_organization
  end

  def create
    authorize get_model
    filter_organization_id
    @record = get_model.new(record_params)
    @organization = get_organization
    if @record.save
      redirect_to(session.delete(:return_to),
                   organization_id: @organization.id,
                   success: t('flashes.create',
                              model: get_model.model_name.human))
    else
      render :new
    end
  end

  def edit
    @record = get_record
    @organization = get_organization
    authorize @record
  end

  def update
    @record = get_record
    @organization = get_organization
    authorize @record
    filter_organization_id
    if @record.update(record_params)
      redirect_to(session.delete(:return_to),
                   organization_id: @organization.id,
                   success: t('flashes.update',
                              model: get_model.model_name.human))
    else
      render :edit
    end
  end

  def destroy
    @record = get_model.find(params[:id])
    authorize @record
    @organization = get_organization
    @record.destroy
    redirect_back(fallback_location: polymorphic_url(@record.class),
                  organization_id: @organization.id,
                  success: t('flashes.destroy',
                              model: get_model.model_name.human))

  end

  private
  def record_params
    params.require(get_model.name.underscore.to_sym)
          .permit(policy(get_model).permitted_attributes)
  end

  def set_show_previous_page
    session[:show_return_to] = request.original_url
  end

  def set_edit_previous_page
    session[:return_to] = request.referer
  end

  def get_record
    @record = get_model.find(params[:id])
    if params[:version_id].present?
      @record = PaperTrail::Version.find(params[:version_id]).reify
    end
    @record
  end

  def get_organization
    if params[:organization_id].present?
      Organization.where(id: params[:organization_id]).first
    elsif params[:q] && params[:q][:organization_id_eq].present?
      Organization.where(id: params[:q][:organization_id_eq]).first
    elsif params[get_model.name.underscore.to_sym] && params[:agreement][:organization_id]
      Organization.where(id: params[get_model.name.underscore.to_sym][:organization_id]).first
    else
      OpenStruct.new(id: nil)
    end
  end

  def filter_organization_id
    id = params[get_model.name.underscore.to_sym][:organization_id].to_i
    unless current_user.admin_editor? || current_user.allowed_organizations_ids.include?(id)
      params[get_model.name.underscore.to_sym][:organization_id] = nil
    end
  end

  def filter_for_organization
    get_model.where(organization_id: @organization.id)
  end

  def default_sort
    'created_at asc'
  end

  def default_includes
    :organization
  end
end
