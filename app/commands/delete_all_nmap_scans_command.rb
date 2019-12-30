# frozen_string_literal: true

class DeleteAllNmapScansCommand < BaseCommand

  set_command_name :delete_all_nmap_scans
  set_human_name 'Удалить все Nmap результаты сканирования'
  set_command_model 'ScanResult'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    scope = ScanResult
    if options[:organization_id].present?
      scope = scope.where(organization_id: options[:organization_id])
    end
    scope = scope.joins(:scan_job).where(scan_jobs: {scan_engine: 'nmap'})
    scope.delete_all

    # TODO: use or delete (case when not only admins allowed to run commands)
    #Pundit.policy_scope(current_user, scope).destroy_all
  end
end
