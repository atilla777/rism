# frozen_string_literal: true

class DestroySchedulesCommand < BaseCommand

  set_command_name :destroy_schedules
  set_human_name 'Удалить все рассписания из базы'
  set_command_model 'Schedule'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    Schedule.destroy_all
  end
end
