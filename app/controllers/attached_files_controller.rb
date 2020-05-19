# frozen_string_literal: true

class AttachedFilesController < ApplicationController
  # Upload file
  def create
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
    #render json: { url: uploaded_url }
    respond_to do |format|
      format.js { render 'attached_files' }
      format.json { render json: {url: result[:uploaded_url]} }
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

  # Delete (deattache) file
  def destroy
    attached_file = AttachedFile.find(params[:id])
    @record = attached_file.filable
    authorize @record
    authorize AttachedFile
    attached_file.destroy
    render 'attached_files'
  end
end
