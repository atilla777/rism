# frozen_string_literal: true

class AttachedFilesController < ApplicationController
  # Upload file
  def create
    if params[:attached_file].present?
      create_file
    else
      create_article_image
    end
  end

  # Download file
  def show
    authorize AttachedFile # Is user allowed to download/upload files?
    attached_file = AttachedFile.find(params[:id])
    authorize attached_file.filable # Is user allowed to view record (filable)?
    send_file(
      FileUploader.file_path(
        attached_file.filable_type.downcase,
        attached_file.filable_id,
        attached_file.new_name
      ),
      filename: attached_file.name,
      disposition: 'attachment',
      x_sendfile: true # Send file direct via nginx
    )
  end

  # Show image in article
  def download_image
    record = Article.find(params[:id])
    authorize record
    send_file(
      FileUploader.file_path(
        'article',
        record.id,
        params[:file_name]
      ),
      disposition: 'attachment',
      x_sendfile: true
    )
  end


  # Delete (deattache) file
  def destroy
    attached_file = AttachedFile.find(params[:id])
    @record = attached_file.filable
    authorize @record
    authorize AttachedFile
    attached_file.destroy
    render 'attached_files'
  end

  private

  # If file attached to record by user
  def create_file
    @record = params[:attached_file][:filable_type].constantize.find(
      params[:attached_file][:filable_id],
    )
    authorize @record
    authorize AttachedFile
    result = FileUploader.upload(
      params[:attached_file][:attachment],
      params[:attached_file][:filable_type],
      params[:attached_file][:filable_id]
    )

    AttachedFile.create(
      name: params[:attached_file][:attachment].original_filename,
      new_name: result[:new_name],
      filable_type: params[:attached_file][:filable_type],
      filable_id: params[:attached_file][:filable_id]
    )

    render 'attached_files'
  end

  # If image attached to article by CKEditor
  def create_article_image
    article = Article.find(session[:editable_article_id])
    authorize article
    result = FileUploader.upload(
      params[:upload],
      'article',
      article.id,
      true
    )
    render json: { url: result[:url]}
  end
end
