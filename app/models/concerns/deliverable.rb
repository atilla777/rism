# frozen_string_literal: true

module Deliverable
  extend ActiveSupport::Concern

  included do
    has_many :delivery_subjects, as: :deliverable, dependent: :delete_all
    has_many :delivery_lists, through: :delivery_subjects
    has_many :delivery_recipients, through: :delivery_lists
    has_many :notifications_logs, as: :deliverable, dependent: :delete_all

  has_many(
    :recipients,
    through: :delivery_recipients,
    source: :recipientable,
    source_type: 'User'
  )
  end

  def allowed_delivery_lists
    DeliveryList.all - delivery_lists
  end

  def report
    nil
  end
end
