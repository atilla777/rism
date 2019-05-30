# frozen_string_literal: true

class SyncNvdBaseCommand < BaseCommand
  set_command_name :sync_nvd_base
  set_human_name 'Синхронизировать данные NVD'
  set_command_model 'Vulnerability'
  set_required_params %i[]

  def run
    return unless @current_user.admin_editor?
    SyncNvdBaseJob.perform_later('sync_nvd_base')
  end
end
