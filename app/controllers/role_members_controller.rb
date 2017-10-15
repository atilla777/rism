class RoleMembersController < ApplicationController
  include DefaultActions

  def index
    authorize RoleMember
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = User.find(params[:q][:user_id_eq])
    end
    @q = RoleMember.where(user_id: @user.id)
                   .ransack(params[:q])
    @records = @q.result
                 .includes(:role)
                 .page(params[:page])
  end

  def new
    authorize RoleMember
    @record = RoleMember.new
    @user = User.find(params[:user_id])
    @roles = Role.all
  end

  def create
    authorize RoleMember
    @roles = Role.all
    @record = RoleMember.new(record_params)
    @user = User.find(params[:role_member][:user_id])
    if @record.save
      redirect_to role_members_path(user_id: @user.id), success: t('flashes.create',
                                               model: get_model.model_name.human)
    else
      render :new
    end
  end

  def destroy
    authorize @record
    @record = get_model.find(params[:id])
    @record.destroy
    redirect_to polymorphic_url(@record.class, user_id: @record.user.id),
      success: t('flashes.destroy', model: get_model.model_name.human)
  end

  private
  def get_model
    RoleMember
  end

  def permit_attributes
    %i[user_id role_id]
  end
end
