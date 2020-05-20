# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_uploaded_files

    has_many :attached_files, as: :filable, dependent: :destroy
  end

  private

  def delete_uploaded_files
    FileUploader.delete_filable_dir(self.class.name.downcase, id)
  end
end
