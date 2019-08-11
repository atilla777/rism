# frozen_string_literal: true

module Readable
  extend ActiveSupport::Concern

  included do
    has_many :readable_logs, as: :readable, dependent: :delete_all
    has_many :users, through: :readable_log
  end

  def read_status(current_user)
    readable_log =  ReadableLog.where(
        user_id: current_user.id,
        readable: self
      )&.first
    return :unreaded unless readable_log
    return :readed if read_create?(readable_log) && read_update?(readable_log)
    return :unreaded unless read_create?(readable_log)
    return :unreaded_update unless read_update?(readable_log)
  end

  private

  def read_create?(readable_log)
    return true if readable_log.read_created_at == created_at
    false
  end

  def read_update?(readable_log)
    return true if readable_log.read_updated_at == updated_at
    false
  end
end
