# frozen_string_literal: true

class CommandsController < ApplicationController
  def run
    command = Commands.command_by_name(params[:name]).new(current_user, params)
    authorize command.class.command_model.constantize
    command.run
    message = {success: t('flashes.command', command: command.class.human_name)}
              # TODO show translated (human) record name in error
  rescue StandardError
    message = {danger: t('flashes.command_faild', command: command.class.human_name)}
  ensure
    redirect_back(
      { fallback_location: polymorphic_url(command.class.command_model.constantize) }
      .merge message
    )
  end
end
