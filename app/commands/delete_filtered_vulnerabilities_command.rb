# frozen_string_literal: true

class DeleteFilteredVulnerabilitiesCommand < BaseCommand

  set_command_name :delete_filtered_vulnerabilities
  set_human_name 'Удалить отфильтрованные записи'
  set_command_model 'Vulnerability'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    clear_base
  end

  private

  def clear_base
    if options[:q].present?
      q = Vulnerability.ransack(options[:q])
      q.result.delete_all
#    else
#      Vulnerability.delete_all
    end
  end
end
