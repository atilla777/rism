class RoleMembersController < ApplicationController
  include Record

  def index
    authorize model
    if params[:user_id]
      @user = User.find(params[:user_id])
    else
      @user = User.find(params[:q][:user_id_eq])
    end
    @q = model.where(user_id: @user.id)
                   .ransack(params[:q])
    @records = @q.result
                 .includes(:role)
                 .page(params[:page])
  end

  def new
    authorize model
    @record = model.new
    @user = User.find(params[:user_id])
    @roles = Role.all
  end

  def create
    authorize model
    @roles = Role.all
    @record = model.new(record_params)
    @user = User.find(params[:role_member][:user_id])
    if @record.save
      redirect_to(
        role_members_path(user_id: @user.id),
        success: t('flashes.create', model: model.model_name.human)
      )
    else
      render :new
    end
  end

  def destroy
    @record = model.find(params[:id])
    authorize @record
    @record.destroy
    redirect_to(
      polymorphic_url(@record.class, user_id: @record.user.id),
      success: t('flashes.destroy', model: model.model_name.human)
    )
  end

  private

  def model
    RoleMember
  end
end
