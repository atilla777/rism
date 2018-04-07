class Ckeditor::AttachmentFilePolicy
  attr_reader :user, :attachment

  def initialize(user, attachment)
    @user = user
    @attachment = attachment
  end

  def index?
    #user.present?
    true
  end

  def create?
    index?
  end

  def destroy?
    index?
  end
end
