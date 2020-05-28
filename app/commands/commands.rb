# frozen_string_literal: true

class Commands
  @@commands = []

  def self.commands
    @@reports
  end

  def self.add_command(command_class)
    @@commands << command_class
  end

  def self.names_where(options)
    @@commands.select do |command|
      next unless command.command_model == options[:command_model]
      (command.required_params - options[:params].keys.to_a).empty?
    end
  end

  def self.command_by_name(name)
    @@commands.find { |command| command.command_name.to_sym == name.to_sym }
  end

  RunAllNmapScans.register
  RunAllShodanScans.register
  RunAllScans.register
  DeleteAllNmapScansCommand.register
  DeleteAllShodanScansCommand.register
  DeleteAllScansCommand.register
  RestorySchedulesCommand.register
  DestroySchedulesCommand.register
  LinkScanJobHostsCommand.register
  DestroyScanJobsLogsCommand.register
  DestroyLostScanJobsLogsCommand.register
  ResetNvdBaseCommand.register
  ResetNvdBaseLastYearCommand.register
  SyncNvdBaseCommand.register
  DeleteFilteredVulnerabilitiesCommand.register
  DeleteFilteredScanResultsCommand.register
  DeleteFilteredHostServicesCommand.register
  DeleteFilteredHostsCommand.register
end
