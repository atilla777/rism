class UploadsController < ApplicationController
  # Download article images from CKEditor
  def create
    uploaded_url = CkeditorUploader.upload(
      params[:upload],
      'article',
      session[:editable_article_id]
    )
    render json: { url: uploaded_url }
  end
end
