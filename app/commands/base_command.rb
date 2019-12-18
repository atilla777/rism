# frozen_string_literal: true

# Commands allow use buttons to make not standard REST actions
# (like  destroy records by some criteria)
class BaseCommand
  def self.register
    Commands.add_command self
  end

  def self.set_command_name(name)
    define_singleton_method(:command_name) { name }
  end

  def self.set_human_name(name)
    define_singleton_method(:human_name) { name }
  end

  def self.set_command_model(name)
    define_singleton_method(:command_model) { name }
  end

  def self.set_required_params(name)
    define_singleton_method(:required_params) { name }
  end

  attr_reader :options, :current_user

  def initialize(current_user, options = {})
    @current_user = current_user
    @options = options
  end
end
