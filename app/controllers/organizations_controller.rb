# frozen_string_literal: true

class OrganizationsController < ApplicationController
  include Record

  before_action :filter_parent_id, only: %i[create update]

  def autocomplete_organization_name
    authorize model
    if current_user.admin_editor?
      scope = Organization
    else
      scope = Organization.where(
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
    scope = policy_scope(model)
    @q = scope.ransack(params[:q])
    @q.sorts = 'name asc' if @q.sorts.empty?
    @records = @q.result
                 .includes(:parent, :organization_kind)
                 .page(params[:page])
  end

  def show
    @record = record
    authorize @record
  end

  def new
    @record = model.new(template_attributes)
    authorize @record.class
    @record.parent_id = current_user.organization_id
    @template_id = params[:template_id]
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
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
  end

  def update
    @record = record
    authorize @record
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
    authorize @record
    message = if @record.destroy
                { success: t('flashes.destroy', model: model.model_name.human) }
              # TODO: show translated (human) record name in error
              else
                { danger: @record.errors.full_messages.join(', ') }
              end
    redirect_to(
      polymorphic_url(@record.class),
      message
    )
  end

  private

#  def record_params
#    params.require(model.name.underscore.to_sym)
#          .permit(policy(model).permitted_attributes)
#  end

  def model
    Organization
  end

  # prevent user to make organization belonging to not allowed organization
  def filter_parent_id
#    return if current_user.admin_editor?
#    id = params[model.name.underscore.to_sym][:parent_id].to_i
#    return if current_user.allowed_organizations_ids.include?(id)
#    params[model.name.underscore.to_sym][:parent_id] = nil
#    params[model.name.underscore.to_sym][:parent_id] = nil
  end
end
