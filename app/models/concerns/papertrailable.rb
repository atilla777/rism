# frozen_string_literal: true

module Papertrailable
  extend ActiveSupport::Concern

  included do
    attr_accessor :skip_versioning
  end

  def previous_version(field)
    previous_record = paper_trail.previous_version
    return previous_record.send(field.to_sym) if previous_record.present?
    ''
  end
end
