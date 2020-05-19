# frozen_string_literal: true

class AttachedFile < ApplicationRecord
  attr_reader :attachment

  before_destroy :delete_uploaded_file

  validates :name, presence: true
  validates :new_name, presence: true
  validates(
    :filable_type,
    uniqueness: {scope: [:filable_id, :new_name]}
  )

  belongs_to :filable, polymorphic: true

  private

  def delete_uploaded_file
    dir = FileUploader.file_dir(filable_type.downcase, filable_id) # absolete path to file dir
    return unless File.directory?(dir)
    file_path = "#{dir}/#{new_name}"
    File.delete(file_path) if File.exist?(file_path)
  end
end
