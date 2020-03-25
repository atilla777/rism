# frozen_string_literal: true

class DeleteFilteredHostServicesCommand < BaseCommand

  set_command_name :delete_filtered_host_services
  set_human_name 'Удалить отфильтрованные записи'
  set_command_model 'HostService'
  set_required_params %i[q]

  def run
    return unless @current_user.admin?
    delete_filtered
  end

  private

  def delete_filtered
    return unless options[:q].present?
    scope = HostService.records_scope
    q = scope.ransack(options[:q])
    q.result.delete_all
  end
end
