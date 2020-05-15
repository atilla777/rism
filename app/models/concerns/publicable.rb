# frozen_string_literal: true

module Publicable
  extend ActiveSupport::Concern

  included do
    has_one :publication, as: :publicable
  end

  def subscriptors
    User.joins(:subscriptions)
        .where(subscriptions: {publicable_type: self.class.name})
  end

  def report
    nil
  end
end
