# frozen_string_literal: true

module Readable
  extend ActiveSupport::Concern

  included do
    has_many :readable_logs, as: :readable, dependent: :delete_all
    has_many :users, through: :readable_log


#  def ransackable_scopes_skip_sanitize_args
#    %i[new_for updated_for new_and_updated_for old_and_updated_for]
#  end

  def self.ransackable_scopes(auth_object = nil)
    %i[new_for updated_for new_and_updated_for old_and_updated_for old_for]
  end

  def self.old_for(user_id)
    sql = <<~SQL
    #{self.table_name}.id IN
      (SELECT readable_logs.readable_id FROM readable_logs
      WHERE
      readable_logs.user_id = ?
      AND readable_logs.read_updated_at = #{self.table_name}.updated_at
      AND readable_logs.readable_id = #{self.table_name}.id
      AND readable_logs.readable_type = '#{self.model_name}')
    SQL
    where(sql, user_id)
  end

  def self.new_for(user_id)
    sql = <<~SQL
    #{self.table_name}.id NOT IN
      (SELECT readable_logs.readable_id FROM readable_logs
      WHERE
      readable_logs.user_id = ?
      AND readable_logs.readable_id = #{self.table_name}.id
      AND readable_logs.readable_type = '#{self.model_name}')
    SQL
    where(sql, user_id)
  end

  def self.updated_for(user_id)
    sql = <<~SQL
      #{self.table_name}.id IN
      (SELECT readable_logs.readable_id FROM readable_logs
      WHERE
      readable_logs.user_id = ?
      AND readable_logs.read_updated_at != #{self.table_name}.updated_at
      AND readable_logs.readable_id = #{self.table_name}.id
      AND readable_logs.readable_type = '#{self.model_name}')
    SQL
    where(sql, user_id)
  end

  def self.new_and_updated_for(user_id)
    sql = <<~SQL
      #{self.table_name}.id NOT IN
      (SELECT readable_logs.readable_id FROM readable_logs
      WHERE
      readable_logs.read_updated_at = #{self.table_name}.updated_at
      AND readable_logs.user_id = ?
      AND readable_logs.readable_id = #{self.table_name}.id
      AND readable_logs.readable_type = '#{self.model_name}')
    SQL
    where(sql, user_id)
  end

  def self.old_and_updated_for(user_id)
    sql = <<~SQL
      #{self.table_name}.id IN
      (SELECT readable_logs.readable_id FROM readable_logs
      WHERE
      readable_logs.user_id = ?
      AND readable_logs.readable_id = #{self.table_name}.id
      AND readable_logs.readable_type = '#{self.model_name}')
    SQL
    where(sql, user_id)
  end
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
