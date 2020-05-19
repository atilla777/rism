class UploadsController < ApplicationController
  # Upload article images from CKEditor
  def create
    uploaded_url = FileUploader.upload(
      params[:upload],
      'article',
      session[:editable_article_id]
    )
    render json: { url: uploaded_url }
  end
end
