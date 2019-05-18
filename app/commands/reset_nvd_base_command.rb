# frozen_string_literal: true

class ResetNvdBaseCommand < BaseCommand
  NVD_START_YEAR = 2018 #2002

  set_command_name :reset_nvd_base
  set_human_name 'Пересоздать данные NVD'
  set_command_model 'Vulnerability'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    (NVD_START_YEAR..Time.current.year).each do |year|
      ResetNvdBaseJob.perform_later('reset_nvd_base', year)
    end
  end
end
