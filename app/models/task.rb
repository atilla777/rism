# frozen_string_literal: true

class Task < ApplicationRecord
  include OrganizationMember
  include Rightable
  include Linkable
  include Tagable
  include Readable
  include Monitorable
  include Attachable
  include Task::Ransackers
  include Commentable

  has_paper_trail

  validates :name, uniqueness: true
  validates :name, length: { in: 1..200 }
  validates :parent_id, numericality: { only_integer: true, allow_blank: true }
  validates :user_id, numericality: { only_integer: true }
  validates :task_status_id, numericality: { only_integer: true }
  validates :task_priority_id, numericality: { only_integer: true }

  validate :parent_id_not_self_id

  belongs_to :parent, class_name: 'Task', optional: true
  belongs_to :user
  belongs_to :task_status
  belongs_to :task_priority

  has_many :children,
           class_name: 'Task',
           foreign_key: :parent_id,
           dependent: :destroy
  

  before_save :prepare_tags

  def parent_id_not_self_id
    return unless id
    errors.add(:parent_id, :self_as_parent) if parent_id == id
  end
  
  private

  def prepare_tags
    # TODO: execute only if some of descriptions fields changed
    self.task_tags = []
    self.task_tags.concat(select_tags(description)) 
    self.task_tags.concat(select_tags(current_description)) 
    self.task_tags.concat(select_tags(user_description)) 
  end
  
  def select_tags(text)
    text.scan(/#[[:word:]]*/).flatten
  end
end
