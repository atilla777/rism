# frozen_string_literal: true

class DeleteFilteredVulnerabilityCommand < BaseCommand

  set_command_name :delete_filtered_vulnerability
  set_human_name 'Удалить отфильтрованные записи'
  set_command_model 'Vulnerability'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    clear_base
  end

  private

  def clear_base
    scope = Vulnerability.includes(:vulnerability_bulletins)
    if options[:q].present?
      q = scope.ransack(options[:q])
      q.sorts = options[:q].fetch('s', default_sort)
      q.result
    else
      scope.all.sort(default_sort)
    end
    scope.destroy_all
  end
end
