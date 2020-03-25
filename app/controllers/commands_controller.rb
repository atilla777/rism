# frozen_string_literal: true

class CommandsController < ApplicationController
  def run
    command = Commands.command_by_name(params[:name]).new(current_user, params)
    authorize command.class.command_model.constantize
    command.run
    message = {success: t('flashes.command', command: command.class.human_name)}
  rescue StandardError => error
    message = {danger: t('flashes.command_failed', command: "command.class.human_name #{error}")}
  ensure
    redirect_back(
      { fallback_location: polymorphic_url(command.class.command_model.constantize) }
      .merge message
    )
  end
end
