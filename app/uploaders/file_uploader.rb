# frozen_string_literal: true

class FileUploader
  # Base file storage dir is RAILS ROOT/file_storge

  MAX_FILE_SIZE = 5000000 # Max uploaded file SIZE in bytes (current value is 5 Mb)
  ALLOWED_IMAGE_EXTENSIONS = %w[jpg jpeg gif png tif].freeze
  ALLOWED_DOCUMENT_EXTENSIONS = %w[doc docx xls xlsx ppt pptx vsd vsdx csv json ppt pdf odt txt rtf rar zip 7z tar gz].freeze

  def self.upload(*args, &block)
    new(*args, &block).upload
  end

  def self.file_path(record_type, record_id, filename)
    Rails.root.join(
      'file_storage',
      record_type,
      record_id.to_s,
      filename
    )
  end

  def self.file_dir(record_type, record_id)
    Rails.root.join(
      'file_storage',
      record_type,
      record_id.to_s
    )
  end

  def self.file_base_url(resource, record_id)
    [
      ActionController::Base.relative_url_root,
      resource,
      record_id,
      'files'
    ].join('/')
  end

  def self.delete_filable_dir(filable_type, filable_id)
    dir = FileUploader.file_dir(filable_type, filable_id) # absolete path to images dir
    FileUtils.rm_rf(dir) if File.directory?(dir)
  end

  def initialize(uploaded_io, record_model, record_id, is_article = false)
    @uploaded_io = uploaded_io
    @record_class = record_model.downcase
    @record_id = record_id
    @store_dir = store_dir
    @file_ext = extname
    @new_filename = new_filename
    @file_path = file_path
    @file_url = file_url
    @is_article = is_article
  end

  def extname
    File.extname(@uploaded_io.original_filename).gsub('.', '')
  end

#  def extname
#    mime_type = @uploaded_io.content_type
#    mime_type.gsub!(/x-|-compressed/, '') # Nginx change mime archives types to x- preffix and -compressed suffix
#    MIME::Types[mime_type].first.extensions.first
#  end

  def upload
    return nil if extension_not_allowed?
    return nil if size_not_allowed?
    FileUtils.mkdir_p(@store_dir) unless File.directory?(@store_dir)
    save_file
    {url: @file_url, new_name: @new_filename}
  end

  private

  def save_file
    File.open(@file_path, 'wb') do |file|
      file.write(@uploaded_io.read)
    end
  end

  def extension_not_allowed?
    if @is_article
      ALLOWED_IMAGE_EXTENSIONS.exclude? @file_ext
    else
      (ALLOWED_DOCUMENT_EXTENSIONS + ALLOWED_IMAGE_EXTENSIONS).exclude? @file_ext
    end
  end

  def size_not_allowed?
    @uploaded_io.size > MAX_FILE_SIZE
  end

  def store_dir
    Rails.root.join(
      'file_storage',
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
    return nil unless @record_class == 'article'
    [
      ActionController::Base.relative_url_root,
      @record_class.pluralize,
      @record_id,
      'files',
      @new_filename
    ].join('/')
  end
end
