require_relative '20171203095108_create_attachments.rb'
require_relative '20171203100515_create_attachment_links.rb'

class RevertAttachmentsAndAttachmentLinks < ActiveRecord::Migration[5.1]
  def change
    revert CreateAttachments
    revert CreateAttachmentLinks
  end
end
