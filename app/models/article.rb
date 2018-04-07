class Article < ApplicationRecord

  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable

  ransacker :created_at_text do
    Arel.sql("to_char(articles.created_at, 'YYYY.MM.DD')")
  end

  has_paper_trail

  validates :content, presence: true
  validates :name, length: { minimum: 3, maximum: 300 }
  validates :organization_id, numericality: { only_integer: true }
  validates :user_id, numericality: { only_integer: true }

  belongs_to :organization
  belongs_to :user

  has_many :tag_members, as: :record, dependent: :destroy
  has_many :tags, through: :tag_members

  # TODO move code to attachable concern
  has_many :attachment_links, as: :record, dependent: :destroy
  has_many :attachments, through: :attachment_links

  has_many :rights, as: :subject, dependent: :destroy

  # for use with RecordTemplate, Link and
  # in autocomplite (inside controller)
  def show_full_name
    "#{name}, #{user.name}, #{created_at}"
  end
end
