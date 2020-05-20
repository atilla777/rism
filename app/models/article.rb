class Article < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include PgSearch
  include Rightable
  include Deliverable
  include Publicable

  after_update :delete_old_uploaded_images
  before_destroy :delete_all_uploaded_images

  multisearchable against: [:name, :content]

  ransacker :created_at_text do
    Arel.sql("to_char(articles.created_at, 'YYYY.MM.DD')")
  end

  has_paper_trail

  validates :name, length: { minimum: 3, maximum: 300 }
  validates :user_id, numericality: { only_integer: true }

  belongs_to :user
  belongs_to :articles_folder, optional: true

  # for use with RecordTemplate, Link and
  # in autocomplite (inside controller)
  def show_full_name
    "#{name}, #{user.name}, #{created_at.strftime('%d.%m.%Y')}"
  end

  # Delete images that is not in article content
  def delete_old_uploaded_images
    dir = FileUploader.file_dir('article', id) # absolete path to images dir
    return unless File.directory?(dir)
    base_url = FileUploader.file_base_url('articles', id) # base url path (whithout filename)
    old_files = Dir.children(dir).select do |file| # select files that not in the article content
      not images.include?("#{base_url}/#{file}")
    end
    old_files.each do |file| # delete files that not in article content
      attached_file_existence = AttachedFile.exists?(
        filable_type: 'Article',
        filable_id: id,
        new_name: file)
      next if attached_file_existence  # File is not image in article
      file_path = "#{dir}/#{file}"
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  # Delete folder with article images
  def delete_all_uploaded_images
    images_dir = FileUploader.file_dir('article', id)
    FileUtils.rm_rf(images_dir) if File.directory?(images_dir)
  end

  def delivery_subject_codename
    name
  end

  private

  def images
    require 'nokogiri'
    require 'open-uri'

    doc = Nokogiri::HTML(content)
    current_images = doc.css('img').map{|links| links['src']}

    doc = Nokogiri::HTML(content_was)
    previous_images = doc.css('img').map{|links| links['src']}
    current_images.concat previous_images

    versions.each_with_object(current_images) do |version, memo|
      doc = Nokogiri::HTML(version.reify&.content)
      memo.concat doc.css('img').map{|links| links['src']}
    end.uniq
  end
end
