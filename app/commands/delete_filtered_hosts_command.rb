# frozen_string_literal: true

class DeleteFilteredHostsCommand < BaseCommand

  set_command_name :delete_filtered_hosts
  set_human_name 'Удалить отфильтрованные записи'
  set_command_model 'Host'
  set_required_params %i[q]

  def run
    return unless @current_user.admin?
    delete_filtered
  end

  private

  def delete_filtered
    return unless options[:q].present?
    scope = Host
    q = scope.ransack(options[:q])
    q.result.destroy_all
  end
end
