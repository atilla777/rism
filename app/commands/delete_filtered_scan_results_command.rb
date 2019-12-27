# frozen_string_literal: true

class DeleteFilteredScanResultsCommand < BaseCommand

  set_command_name :delete_filtered_scan_results
  set_human_name 'Удалить отфильтрованные записи'
  set_command_model 'ScanResult'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    clear_base
  end

  private

  def clear_base
    if options[:q].present?
      q = ScanResult.ransack(options[:q])
      q.result.delete_all
#    else
#      ScanResult.delete_all
    end
  end
end
