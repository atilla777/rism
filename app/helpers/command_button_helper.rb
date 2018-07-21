# frozen_string_literal: true

# = Commnad button helper
# Make links to allowed for record or records commands
#
# It assumes that bootstrap and slim is used in the Rails project.
module CommandButtonHelper
  def command_button_for(record_or_records, options = {})
    options = options.select { |key, value| value }
    command_model = case record_or_records
              when ActiveRecord::Relation
                record_or_records.klass
                                 .model_name
              when ActiveRecord::Base
                record_or_records.class
                                 .model_name
              else
                raise(
                  ArgumentError,
                  'It should be a one record or several records.'
                )
              end
    commands = Commands.names_where(
      command_model: command_model,
      params: options
    )
    return if commands.blank?
    render(
      'helpers/command_button',
      commands: commands,
      options: options
    )
  end
end
