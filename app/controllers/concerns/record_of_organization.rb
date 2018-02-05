# frozen_string_literal: true

# Default actions/methods for all models (tables)
# which belongs to organization
# but exclude organization model
# (organization also belongs to parent organization,
#  but use own methods)
module RecordOfOrganization
  extend ActiveSupport::Concern
  include SharedMethods

  def index
    authorize model
    @organization = organization
    if @organization.id
      @records = records(filter_for_organization)
      render 'index'
    else
      @records = records(model)
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
    @organization = organization
    filter_organization_id
    @record = model.new(record_params)
    @record.save!
    redirect_to(
      session.delete(:return_to),
      organization_id: @organization.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @record = record
    @organization = organization
    authorize @record
  end

  def update
    @record = record
    authorize @record
    @organization = organization
    filter_organization_id
    @record.update!(record_params)
    redirect_to(
      session.delete(:return_to),
      organization_id: @organization.id,
      success: t('flashes.update', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @record = model.find(params[:id])
    authorize @record
    @organization = organization
    message = if @record.destroy
                {success: t('flashes.destroy', model: model.model_name.human)}
              # TODO show translated (human) record name in error
              else
                {danger: @record.errors.full_messages.join(', ')}
              end
    redirect_back(
      { fallback_location: polymorphic_url(@record.class),
        organization_id: @organization.id }
      .merge message
    )
  end

  private

  # get organization to wich record belongs
  def organization
    id = if params[:organization_id]
           params[:organization_id]
         elsif params.dig(:q, :organization_id_eq)
           params[:q][:organization_id_eq]
         elsif params.dig(model.name.underscore.to_sym, :organization_id)
           params[model.name.underscore.to_sym][:organization_id]
         end
    Organization.where(id: id).first || @record&.organization || OpenStruct.new(id: nil)
  end

  # prevent user to make record belonging to not allowed organization
  def filter_organization_id
    return if current_user.admin_editor?
    id = params[model.name.underscore.to_sym][:organization_id].to_i
    return if current_user.allowed_organizations_ids.include?(id)
    params[model.name.underscore.to_sym][:organization_id] = nil
  end

  # filter used in index pages wich is a part of organizaion show page
  # (such index shows only records that belongs to organization)
  def filter_for_organization
    model.where(organization_id: @organization.id)
  end

  # N+1 problem resolving
  def default_includes
    :organization
  end
end
