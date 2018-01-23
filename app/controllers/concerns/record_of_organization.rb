# frozen_string_literal: true

# default actions/methods for all models (tables)
# which belongs to organization
# but exclude organization model
# (organization also belongs to parent organization)
module RecordOfOrganization
  extend ActiveSupport::Concern
  include SharedMethods

  def index
    authorize model
    @organization = organization
    if @organization.id.present?
      scope = filter_for_organization
    else
      scope = model
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
    @record = record
    authorize @record
    @organization = organization
  end

  def new
    authorize model
    @record = model.new
    @organization = organization
  end

  def create
    authorize model
    filter_organization_id
    @record = model.new(record_params)
    @organization = organization
    if @record.save
      redirect_to(session.delete(:return_to),
                   organization_id: @organization.id,
                   success: t('flashes.create',
                              model: model.model_name.human))
    else
      render :new
    end
  end

  def edit
    @record = record
    @organization = organization
    authorize @record
  end

  def update
    @record = record
    @organization = organization
    authorize @record
    filter_organization_id
    if @record.update(record_params)
      redirect_to(session.delete(:return_to),
                  organization_id: @organization.id,
                  success: t('flashes.update',
                             model: model.model_name.human))
    else
      render :edit
    end
  end

  def destroy
    @record = model.find(params[:id])
    authorize @record
    @organization = organization
    @record.destroy
    redirect_back(fallback_location: polymorphic_url(@record.class),
                  organization_id: @organization.id,
                  success: t('flashes.destroy',
                             model: model.model_name.human))

  end

  private
  def record_params
    params.require(model.name.underscore.to_sym)
          .permit(policy(model).permitted_attributes)
  end

  # get organization to wich record belongs
  def organization
    if params[:organization_id].present?
      Organization.where(id: params[:organization_id]).first
    elsif params[:q] && params[:q][:organization_id_eq].present?
      Organization.where(id: params[:q][:organization_id_eq]).first
    elsif params[model.name.underscore.to_sym] && params[:agreement][:organization_id]
      Organization.where(id: params[model.name.underscore.to_sym][:organization_id]).first
    else
      OpenStruct.new(id: nil)
    end
  end

  # prevent user to make record belonging to not allowed organization
  def filter_organization_id
    id = params[model.name.underscore.to_sym][:organization_id].to_i
    unless current_user.admin_editor? || current_user.allowed_organizations_ids.include?(id)
      params[model.name.underscore.to_sym][:organization_id] = nil
    end
  end

  # filter used in index pages wich is a part of organizaion show page
  # (such index shows only records that belongs to organization)
  def filter_for_organization
    model.where(organization_id: @organization.id)
  end

  # set sort field and direction by default
  # (applies when go to index page from other place)
  def default_sort
    'created_at asc'
  end

  # method resolves N+1 problem
  def default_includes
    :organization
  end
end
