# frozen_string_literal: true

# Don`t include in model that can be deleted through dependent: delete_all (like ScanResult)
module Rightable
  extend ActiveSupport::Concern

  included do
    has_many :rights, as: :subject, dependent: :delete_all
  end
end
