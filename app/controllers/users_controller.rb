class UsersController < ApplicationController
  include DefaultActions
  include Organizatable

  def index
    authorize get_model
    if params[:department_id].present?
      @department = Department.find(params[:department_id])
      scope = @department.users
      r = 'department_users'
    else
      scope = User
      r = 'index'
    end
    @q = scope.ransack(params[:q])
    @records = @q.result
                 .includes(:organization)
                 .page(params[:page])
    render r
  end

  private
  def get_model
    User
  end
end
