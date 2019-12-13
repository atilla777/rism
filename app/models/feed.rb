# frozen_string_literal: true

class Feed < ApplicationRecord
  validates :name, length: { in: 3..100 }
end
