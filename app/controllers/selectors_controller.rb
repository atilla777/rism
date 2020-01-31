# frozen_string_literal: true

class SelectorsController < ApplicationController
  def index
    if type_not_present?
      return render render_error
    end
    # authorize
    @selected = session[:selected][record_type]
  end
#
#  def show
#  end

  def create
    if type_and_id_not_present?
      return render json: {success: false, errors: ['Required params not set.']}
    end
    #authorize
    @id = set_selected
  end

  def destroy
    if type_not_present?
      return render json: {success: false, errors: ['Required params not set.']}
    end
    reset_selectd
  end

  private

  def set_selected
    session[:selected] ||= {}
    model = record_type
    id = params[:selected_record_id]
    session[:selected][model] || = []
    session[:selected][model] += id
    session[:selected][model] = session[:selected][model].uniq
    id
  end

  def reset_selectd
    session[:selected].delete :selected_articles_folders
  end

  def record_type
    params[:selected_record_type]
  end

  def type_not_present?
    return false if params[:selected_record_type].present?
    true
  end

  def type_and_id_not_present?
    return false if params[:selected_record_type].present? &&
      params[:selected_record_id].present?
    true
  end

  def render_error
    render json: {success: false, errors: ['Required params not set.']}
  end
end
