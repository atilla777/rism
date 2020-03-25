# frozen_string_literal: true

class DeleteFilteredVulnerabilitiesCommand < BaseCommand

  set_command_name :delete_filtered_vulnerabilities
  set_human_name 'Удалить отфильтрованные записи'
  set_command_model 'Vulnerability'
  set_required_params %i[q]

  def run
    return unless @current_user.admin?
    delete_filtered_vulnerabilities
  end

  private

  def delete_filtered_vulnerabilities
    return unless options[:q].present?
    q = Vulnerability.ransack(options[:q])
    q.result.delete_all
  end
end
