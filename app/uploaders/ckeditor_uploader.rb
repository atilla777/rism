# frozen_string_literal: true

#require 'mime/types'

class CkeditorUploader
  def self.upload(*args, &block)
    new(*args, &block).upload
  end

  def initialize(uploaded_io, record_model, record_id)
    @uploaded_io = uploaded_io
    @record_class = record_model
    @record_id = record_id
    @store_dir = store_dir
    @file_ext = extname
    @new_filename = new_filename
    @file_path = file_path
    @file_url = file_url
  end

  def extname
    MIME::Types[@uploaded_io.content_type].first.extensions.first
  end

  def upload
    return nil if extension_not_allowed?
    FileUtils.mkdir_p(store_dir) unless File.directory?(store_dir)
    save_file
    @file_url
  end

  private

  def save_file
    File.open(@file_path, 'wb') do |file|
      file.write(@uploaded_io.read)
    end
  end

  def extension_not_allowed?
    if %w(jpg jpeg gif png tif).include? @file_ext
      false
    else
      true
    end
  end

  def store_dir
    Rails.root.join(
      'public',
      'uploads',
      'ckeditor',
      @record_class,
      @record_id.to_s
    )
  end

  def new_filename
    "#{SecureRandom.uuid}.#{@file_ext}"
  end

  def file_path
    "#{@store_dir}/#{@new_filename}"
  end

  def file_url
      [
        ActionController::Base.relative_url_root,
        'uploads',
        'ckeditor',
        @record_class,
        @record_id,
        @new_filename
      ].join('/')
  end
end
