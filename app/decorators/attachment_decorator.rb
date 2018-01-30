# frozen_string_literal: true

class AttachmentDecorator < SimpleDelegator
  def show_file_name
    if name.present?
      "#{name} (#{document_identifier.truncate(20)})"
    else
      document_identifier
    end
  end
end
