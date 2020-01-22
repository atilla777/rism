class Article < ApplicationRecord

  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include PgSearch
  include Rightable

  before_destroy :delete_images

  multisearchable against: [:name, :content]

  ransacker :created_at_text do
    Arel.sql("to_char(articles.created_at, 'YYYY.MM.DD')")
  end

  has_paper_trail

  validates :content, presence: true
  validates :name, length: { minimum: 3, maximum: 300 }
  validates :user_id, numericality: { only_integer: true }

  belongs_to :user

  # for use with RecordTemplate, Link and
  # in autocomplite (inside controller)
  def show_full_name
    "#{name}, #{user.name}, #{created_at.strftime('%d.%m.%Y')}"
  end

  def delete_images
    images.each do |image|
      file_path = "#{Rails.root}#{image}"
      File.delete(file_path) if File.exist?(file_path)
    end
  end

  private

  def images
    require 'nokogiri'
    require 'open-uri'
    doc = Nokogiri::HTML(content)
    doc.css("img").map{|links| links['src']}
  end
end
