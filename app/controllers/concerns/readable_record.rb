# frozen_string_literal: true

module ReadableRecord
  extend ActiveSupport::Concern

  included do
    after_action(
      :set_readable_log,
      only: [:create, :show, :edit, :update]
    )
  end

#  def set_readable
#    @record = record
#    authorize @record.class
#    set_readable_log(@record)
#  end

  def toggle_readable
    @record = record
    authorize @record.class
    toggle_readable_log(@record)
    render 'set_readable'
  end

  private

  def set_readable_log(readable_record = @record)
    SetReadableLogService.call(readable_record, current_user)
  end

  def toggle_readable_log(readable_record = @record)
    ToggleReadableLogService.call(readable_record, current_user)
  end
end
