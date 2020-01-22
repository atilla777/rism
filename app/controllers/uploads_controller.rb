class UploadsController < ApplicationController
  def create
    uploader = CkeditorPictureUploader.new
    #byebug
    uploader.store!(params[:upload])
    render json: { url: uploader.url }
  end
end
