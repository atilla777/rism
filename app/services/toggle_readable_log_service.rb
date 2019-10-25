class ToggleReadableLogService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(readable, current_user)
     @readable = readable
     @user = current_user
  end

  def execute
    @readable_log = ReadableLog.where(
      user_id: @user.id,
      readable_type: original_class.name,
      readable_id: @readable.id
    ).first_or_initialize
    if @readable_log.read_created_at == @readable.created_at
      if @readable_log.read_updated_at == @readable.updated_at
        set_as_unreaded
      else
        set_as_readed
      end
    else
      set_as_readed
    end
  end

  private

  def set_as_readed
    @readable_log.read_created_at = @readable.created_at
    @readable_log.read_updated_at = @readable.updated_at
    @readable_log.save
  end

  def set_as_unreaded
    @readable_log.destroy
  end

  def original_class
    return @readable.__getobj__.class if @readable.respond_to?(:__getobj__)
    @readable.class
  end
end
