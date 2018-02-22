class TagKind < ApplicationRecord
  validates :name, length: { minimum: 1, maximum: 100 }
  validates :code_name, length: { minimum: 1, maximum: 10 }
  validates :name, uniqueness: true
  validates :code_name, uniqueness: true

  has_many :tags, dependent: :destroy

  def name_with_code
    TagKindDecorator.new(self).name_with_code
  end
end
