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
    authorize @record
  end

  def new
    authorize model
    @record = model.new
  end

  def create
    authorize model
    @record = model.new(record_params)
    @record.save!
    redirect_to(
      polymorphic_path(@record),
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @record = record
    authorize @record
  end

  def update
    @record = record
    authorize @record
    @record.update!(record_params)
    redirect_to(
      @record,
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

  # N+1 problem resolving
  def default_includes; end
end
