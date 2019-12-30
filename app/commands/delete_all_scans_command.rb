# frozen_string_literal: true

class DeleteAllScansCommand < BaseCommand

  set_command_name :delete_all_scans
  set_human_name 'Удалить все результаты сканирования'
  set_command_model 'ScanResult'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    scope = ScanResult
    if options[:organization_id].present?
      scope = scope.where(organization_id: options[:organization_id])
    end

    scope.delete_all

    # TODO: use or delete (case when not only admins allowed to run commands)
    # Pundit.policy_scope(current_user, scope).destroy_all
  end
end
