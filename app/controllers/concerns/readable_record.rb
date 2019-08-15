# frozen_string_literal: true

module ReadableRecord
  extend ActiveSupport::Concern

  included do
    after_action(
      :set_readable_log,
      only: [:create, :show, :edit, :update]
    )
  end

  def set_readable
    @record = record
    authorize @record
    set_readable_log(@record)
  end

  private

  def set_readable_log(readable_record = @record)
    SetReadableLogService.call(readable_record, current_user)
  end
end
