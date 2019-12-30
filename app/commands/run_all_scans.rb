# frozen_string_literal: true

class RunAllScans < BaseCommand

  set_command_name :run_all_scans
  set_human_name 'Запустить все сканирования'
  set_command_model 'ScanJob'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    scope = ScanJob.all
    if options[:organization_id].present?
      scope = scope.where(organization_id: options[:organization_id])
    end
    scope.each do |scan_job|
      unless @current_user.admin_editor?
        unless @current_user.can?(:edit, scan_job)
          next
        end
      end
      NetScanJob.perform_later(
        scan_job.id,
        scan_job.job_queue('now_scan')
      )
    end
  end
end
