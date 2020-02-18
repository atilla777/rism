# frozen_string_literal: true

class SelectorsController < ApplicationController
  def index
    selected_type = model
    authorize selected_type.constantize
    ids = session.fetch(:selected, {}).fetch(selected_type, [])
    @records = selected_type.constantize.where(id: ids)
    render template: 'application/modal_index.js.erb'
  end

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
