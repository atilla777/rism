# frozen_string_literal: true

class RecordAttachmentsDecorator < SimpleDelegator
  def show_attachments
    attachments.map { |a| a.name.present? ? a.name : a.document_identifier }
               .join(', ')
  end
end
