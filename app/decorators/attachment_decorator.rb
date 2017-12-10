class AttachmentDecorator < SimpleDelegator
  def show_file_name
    name.present?  ? "#{name} (#{document_identifier.truncate(20)})" : document_identifier
  end
end
