class Role < ApplicationRecord
  before_destroy :protect_main_roles

  has_many :role_members, dependent: :destroy
  has_many :users, through: :role_members

  has_many :rights, dependent: :destroy

  validates :name, length: { minimum: 3, maximum: 100}
  validates :name, uniqueness: true

  def protect_main_roles
    if (1..3).include? id
      throw :abort
    end
  end
end
