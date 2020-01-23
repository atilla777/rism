# frozen_string_literal: true
# encoding: utf-8

class CkeditorPictureUploader < CarrierWave::Uploader::Base
  #include Ckeditor::Backend::CarrierWave
  # Include RMagick or ImageScience support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick
  # include CarrierWave::ImageScience

  # Choose what kind of storage to use for this uploader:
  storage :file

  #after :remove, :delete_document_dir

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    #date = DateTime.current.strftime("%Y.%m")
    article_id = session[:editable_article_id]
    date = article_id
    "uploads/ckeditor/pictures/#{date}"
  end

  def cache_dir
    "uploads/ckeditor/cache"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process scale: [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  #process :extract_dimensions

  # Create different versions of your uploaded files:
#  version :thumb do
#    process resize_to_fill: [118, 100]
#  end

#  version :content do
#    process resize_to_limit: [800, 800]
#  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  def extension_white_list
    %w(jpg jpeg gif png tif)
  end

  def filename
     reuturn unless original_filename
     "#{SecureRandom.uuid}.#{file.extension}"
  end

#  def delete_document_dir
#    path = File.expand_path(store_dir, root)
#    Dir.rmdir(path)
#  rescue
#    true
#  end
end
