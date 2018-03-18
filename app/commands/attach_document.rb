# TODO: user or delete
class AttacheDocument
  def initilaize(record, files)
    @files = files
    @record = record
  end

  def run
    @files.each do | file |
      attachmenet = Attachment.new(document: file)
      attachmenet.save
      attachmenet_link = AttachemnetLink.new(record_type: @record.class.to_s.downcase, record_id: @record.id, attachmenet_id: attachment.id)
      attachmenet_link.save
    end
  end
end
