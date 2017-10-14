module DefaultActions
  extend ActiveSupport::Concern

  def index
    @q = get_model.ransack(params[:q])
    @records = @q.result
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
end
