# frozen_string_literai: true

class TornadosJob < ApplicationJob
  queue_as do
    self.arguments&.first || :default
  end

  def perform(queue)
    TornadosService.call
  # rescue StandardError => error
  #   log_error(error)
  end

  private

  def log_error(error)
    logger = ActiveSupport::TaggedLogging.new(Logger.new('log/rism_error.log'))
    logger.tagged("TORNADOS (#{Time.now}): ") do
      logger.error(%W(Tor exit nodes file can`t be create -#{error}.))
    end
  end
end
