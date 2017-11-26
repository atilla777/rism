class  VersionDecorator < SimpleDelegator
  def last_version_info
    result = []
    if versions.present?
      result << versions.size
      result << versions.last.event
      result << created_at.strftime("%d.%m.%Y-%H:%m")
      result << User.find(paper_trail.originator).name
    end
    result.join(' ')
  end

  def version_info
    result = []
    result << index + 1
    result << "id:#{id}"
    result << event
    result << created_at.strftime("%d.%m.%Y-%H:%m")
    result << User.find(version_author).name
    result.join(' ')
  end
end
