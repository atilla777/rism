# frozen_string_literal: true

class DestroyLostScanJobsLogsCommand < BaseCommand

  set_command_name :destroy_lost_scan_jobs_logs
  set_human_name 'Удалить все записи журнала с отсутствующими фоновыми процессами'
  set_command_model 'ScanJobLog'
  set_required_params %i[]

  def run
    lost_worker_logs.each(&:destroy)
  end

  private

  def lost_worker_logs
    allowed_logs.each_with_object([]) do |log, memo|
      next if log.finish.present?
      memo << log unless log.working?
    end
  end

  def allowed_logs
    scope = ScanJobLog
    if options[:job].present?
      scope = scope.where(scan_job_id: options[:job])
    end
    Pundit.policy_scope(current_user, scope).all
  end
end
