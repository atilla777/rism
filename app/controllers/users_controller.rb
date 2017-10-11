class UsersController < ApplicationController
  def index
    @q = User.ransack(params[:q])
    @users = @q.result
               .order(name: :asc)
               .page(params[:page])
  end

  def show
    @user = set_user
  end

  def new
    @user = User.new
    @organizations = set_organizations
  end

  def create
    @user = User.new(user_params)
    if @user.save
      redirect_to users_path, success: t('flashes.create', model: User.model_name.human)
    else
      @organizations = set_organizations
      render :new
    end
  end

  def edit
    @user = set_user
    @organizations = set_organizations
  end

  def update
    @user = set_user
  end

  def destroy
    @user = set_user
  end

  private
  def set_user
    User.find(params[:id])
  end

  def set_organizations
    Organization.all
  end

  def user_params
    params.require(:user).permit(:name,
                                 :organization_id,
                                 :email,
                                 :phone,
                                 :mobile_phone,
                                 :job,
                                 :active,
                                 :password,
                                 :password_confirmation)
  end
end
