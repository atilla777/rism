# frozen_string_literal: true

module Recipientable
  extend ActiveSupport::Concern

  included do
    has_many :delivery_recipients, as: :recipientable, dependent: :delete_all
    has_many :delivery_lists, through: :delivery_recipients
  end
end
