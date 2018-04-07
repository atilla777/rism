class Ckeditor::PicturePolicy
  attr_reader :user, :picture

  def initialize(user, picture)
    @user = user
    @picture = picture
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
