# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include Record

  #before_action :filter_parent_id, only: %i[create update]

  def autocomplete_organization_name
    authorize model
    scope = if current_user.admin_editor?
              Organization
            elsif current_user.can_read_model_index? Organization
              Organization
            else
              Organization.where(
                id: current_user.allowed_organizations_ids
              )
            end

    term = params[:term]
    records = scope.select(:id, :name)
                       .where('name ILIKE ? OR id::text LIKE ?', "%#{term}%", "#{term}%")
                       .order(:id)
    result = records.map do |record|
               {
                 id: record.id,
                 name: record.name,
                 :value => record.name
               }
             end
    render json: result
  end

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
#    scope = policy_scope(model)
#    @q = scope.ransack(params[:q])
#    @q.sorts = 'name asc' if @q.sorts.empty?
#    @records = @q.result
#                 .includes(:parent, :organization_kind)
#                 .page(params[:page])
  end

  def show
    @record = record
    authorize @record
  end

  def new
    @record = model.new(template_attributes)
    authorize @record.class
    @organization = organization
    @record.parent_id = @organization.present? ? @organization.id : current_user.organization_id
    @template_id = params[:template_id]
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    @organization = organization
    @record.current_user = current_user
    @record.save!
    add_tags_from_template
    redirect_to(
      session.delete(:edit_return_to),
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
    redirect_to(
      session.delete(:edit_return_to),
      success: t('flashes.update', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @record = record
    @organization = organization
    authorize @record
    message = if @record.destroy
                { success: t('flashes.destroy', model: model.model_name.human) }
              # TODO: show translated (human) record name in error
              else
                { danger: @record.errors.full_messages.join(', ') }
              end
    redirect_back(
      { fallback_location: polymorphic_url(@record.class),
        organization_id: @organization.id }
      .merge message
    )
  end

  private

  def model
    Organization
  end

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

  def filter_for_organization
    model.where(parent_id: @organization.id)
  end

  def records_includes
    %i[parent organization_kind]
  end
end
