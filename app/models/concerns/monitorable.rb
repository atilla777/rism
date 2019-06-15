# frozen_string_literal: true

module Monitorable
  extend ActiveSupport::Concern

  included do
    attr_accessor :current_user

    before_validation :set_created_by, on: :create
    before_validation :set_updated_by, on: :update

    validates :created_by_id, numericality: { only_integer: true, allow_blank: true }, on: :create
    validates :updated_by_id, numericality: { only_integer: true, allow_blank: true }, on: :update

    belongs_to :creator, foreign_key: :created_by_id, class_name: 'User', optional: true
    belongs_to :updater, foreign_key: :updated_by_id, class_name: 'User', optional: true
  end

  def set_created_by
    self.created_by_id = current_user&.id
  end

  def set_updated_by
    self.updated_by_id = current_user&.id
  end
end
