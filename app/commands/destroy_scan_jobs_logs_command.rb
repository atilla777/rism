# frozen_string_literal: true

class DestroyScanJobsLogsCommand < BaseCommand

  set_command_name :destroy_scan_jobs_logs
  set_human_name 'Удалить все записи журнала'
  set_command_model 'ScanJobLog'
  set_required_params %i[]

  def run
   allowed_logs.delete_all
  end

  private

  def allowed_logs
    scope = ScanJobLog
    if options[:job].present?
      scope = scope.where(scan_job_id: options[:job])
    end
    Pundit.policy_scope(current_user, scope)
  end
end
