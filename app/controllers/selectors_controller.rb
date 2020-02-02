# frozen_string_literal: true

class SelectorsController < ApplicationController
#  def index
#    @model = model
#    if @model.present?
#      authorize @model.constantize
#      @ids = session[:selected][@model]
#    else
#      return render render_error
#    end
#  end

  def update
    @model = model
    @id = id
    if @model.present? && @id.present?
      authorize @model.constantize
      toggle_selection
    else
      return render json: {success: false, errors: ['Required params not set.']}
    end
  end

  def destroy
    @model = model
    @id = id
    if @model.present?
      authorize @model.constantize
      reset_selection
    else
      return render json: {success: false, errors: ['Required params not set.']}
    end
  end

  private

  def model
    params[:selected_record_type]
  end

  def id
    params[:selected_record_id]
  end

  def toggle_selection
    session[:selected] ||= {}
    session[:selected][@model] ||= []
    if session[:selected][@model].include?(@id)
      session[:selected][@model].delete(@id)
    else
      session[:selected][@model] << @id
    end
  end

  def reset_selection
    session[:selected].delete(@model)
  end

  def render_error
    render json: {success: false, errors: ['Required params not set.']}
  end
end
