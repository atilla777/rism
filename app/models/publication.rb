# frozen_string_literal: true

class Publication < ApplicationRecord
  validates(
    :publicable_type,
    uniqueness: { scope: :publicable_id}
  )

  belongs_to :publicable, polymorphic: true
end
