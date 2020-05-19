# frozen_string_literal: true

module Attachable
  extend ActiveSupport::Concern

#  included do
#    has_many :attachment_links, as: :record, dependent: :destroy
#    has_many :attachments, through: :attachment_links
#  end

  included do
    before_destroy :delete_uploaded_files

    has_many :attachment_links, as: :record, dependent: :destroy
    has_many :attachments, through: :attachment_links

    has_many :attached_files, as: :filable, dependent: :destroy
  end

  private

  def delete_uploaded_files
    FileUploader.delete_filable_dir(self.class.name.downcase, id)
  end
end
