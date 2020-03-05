class Article < ApplicationRecord
  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include PgSearch
  include Rightable
  include Deliverable

  after_update :delete_uploaded_images
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
  def delete_uploaded_images
    return unless File.directory?(images_dir)
    dir = images_dir # absolete path to images dir
    url = images_url # path to images strted with /uploads (like in content URL)
    # Select files that not in the content
    Dir.children(dir).select do |file|
      not images.include?("/#{url}/#{file}")
    end.each do |file| # delete files that not in content
      file_path = "#{dir}/#{file}"
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  # Delete folder with article images
  def delete_all_uploaded_images
    FileUtils.rm_rf(images_dir) if File.directory?(images_dir)
  end

  def delivery_subject_codename
    name
  end

  private

  def images_url
  CkeditorUploader.file_dir(id)
#    [
#      'uploads',
#      'ckeditor',
#      'article',
#      id.to_s
#    ].join('/')
  end

  def images_dir
  CkeditorUploader.file_dir('article', id)
#    Rails.root.join(
#      'public',
#      'uploads',
#      'ckeditor',
#      'article',
#      id.to_s
#    )
  end

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
