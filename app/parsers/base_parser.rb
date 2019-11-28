class BaseParser
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(action, content)
    @content = content
    @action = action
  end

  def execute
    self.send @action
  end
end

