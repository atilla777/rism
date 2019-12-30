# frozen_string_literal: true

class RestorySchedulesCommand < BaseCommand

  set_command_name :restory_schedules
  set_human_name 'Восстановить расписание из базы'
  set_command_model 'Schedule'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    Schedule.all.each do |schedule|
      schedule.destroy_sidekiq_cron_schedule
      cron_job_name = "#{schedule.job_type}_#{schedule.job_id}"
      Sidekiq::Cron::Job.create(
        name: cron_job_name,
        cron: schedule.show_crontab_line,
        class: schedule.job.worker,
        queue: schedule.job.job_queue('scheduled_scan'),
        args: [schedule.job.id, schedule.job.job_queue('scheduled_scan')]
      )
    end
  end
end
