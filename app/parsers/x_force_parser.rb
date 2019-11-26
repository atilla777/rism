module XForceParser
  def danger?(content)
    false
  end

  def kaspesky_danger_verdict(content)
    ''
  end

  module_function :danger?, :kaspesky_danger_verdict
end
