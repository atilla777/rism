class  RecordAttachmentsDecorator < SimpleDelegator
  def show_attachments
    result = []
    attachments.each do | a |
      if a.name.present?
      result << a.name 
      else
        result << a.document_identifier
      end
    end
    result.join(', ')
  end
end
