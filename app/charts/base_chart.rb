# frozen_string_literal: true

class BaseChart
  def self.register
    Charts.add_chart self
  end

  def self.set_lang(lang)
    define_singleton_method(:lang) { lang }
  end

  def self.set_chart_name(name)
    define_singleton_method(:chart_name) { name }
  end

  def self.set_human_name(name)
    define_singleton_method(:human_name) { name }
  end

  def self.set_kind(kind)
    define_singleton_method(:kind) { kind }
  end

  attr_reader :chart_data, :current_user

  def initialize(current_user, options = {})
    @current_user = current_user
    @options = options
    @chart_data = chart
  end
end
