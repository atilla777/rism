class Article < ApplicationRecord

  include OrganizationMember
  include Linkable
  include Tagable
  include Attachable
  include PgSearch
  include Rightable

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
end
