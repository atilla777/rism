# frozen_string_literal: true

# Default actions/methods for all models (tables)
# which belongs to organization
# but exclude organization model
# (organization also belongs to parent organization,
#  but use own methods)
module RecordOfOrganization
  extend ActiveSupport::Concern
  include SearchFilterable
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
    respond_to do |format|
      format.js  { render template: 'application/modal_show.js.erb' }
      format.html
    end
  end

  def new
    @record = model.new(template_attributes)
    authorize @record.class
    @organization = organization
    preset_record
    @template_id = params[:template_id]
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    @organization = organization
    @record.current_user = current_user
    @record.save!
    add_from_template
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    @template_id = params[:template_id]
    render :new
  end

  def edit
    @record = record
    authorize @record
    @organization = organization
  end

  def update
    @record = record
    authorize @record
    @organization = organization
    @record.current_user = current_user
    @record.update!(record_params)
    default_update_redirect_to
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @record = record
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

  def default_update_redirect_to
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      success: t('flashes.update', model: model.model_name.human)
    )
  end

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

  # filter that used in index pages wich is a part of organizaion show page
  # (such index shows only records that belongs to organization)
  def filter_for_organization
    model.where(organization_id: @organization.id)
  end

  # N+1 problem resolving
  def records_includes
    :organization unless current_user.admin_editor_reader?
  end

  def preset_record; end
end
