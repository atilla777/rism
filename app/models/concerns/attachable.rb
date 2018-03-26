# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern

  included do
    has_many :attachment_links, as: :record, dependent: :destroy
    has_many :attachments, through: :attachment_links
  end
end
