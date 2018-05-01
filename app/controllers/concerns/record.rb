# frozen_string_literal: true

# default actions/methods for all models (tables)
# which not belongs to organization
# (organization model included)
module Record
  extend ActiveSupport::Concern
  include SharedMethods

  def index
    authorize model
    @records = records(model)
  end

  def show
    @record = record
    authorize @record.class
    render 'show_without_tabs'
  end

  def new
    @record = model.new(template_attributes)
    authorize @record.class
    @template_id = params[:template_id]
  end

  def create
    @record = model.new(record_params)
    authorize @record.class
    @record.save!
    add_from_template
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
    authorize @record.class
  end

  def update
    @record = record
    authorize @record.class
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
    authorize @record.class
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

  # N+1 problem resolving
  def records_includes; end
end
