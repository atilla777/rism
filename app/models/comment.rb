class Comment < ApplicationRecord
  belongs_to :commentable, polymorphic: true
  belongs_to :user
  belongs_to :parent, class_name: 'Comment', optional: true

  has_many :children,
           class_name: "Comment",
           foreign_key: :parent_id,
           dependent: :destroy
  
  validates :user_id, numericality: {only_integer: true} 
  validates :parent_id, numericality: {only_integer: true, allow_blank: true}
end
