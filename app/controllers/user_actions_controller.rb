# frozen_string_literal: true

class UserActionsController < ApplicationController
  include Record

  def index
    authorize model
    user_id = if params[:user_id]
                params[:user_id]
              elsif params[:q]
                params[:q].fetch(:user_id_eq, nil)
              end
    @user = User.find(user_id) if user_id.present?
    scope = if @user
              model.where(user_id: @user.id)
            else
              model
            end
    @records = records(scope)
  end

  def show
    @record = record
    authorize @record.class
  end

  private

  def model
    UserAction
  end

  def default_sort
    'created_at desc'
  end

  def records_includes
    %i[user organization]
  end

  def filter_for_organization
    model.joins('JOIN users ON users.id = user_actions.user_id')
         .where('users.organization_id = ?', @organization.id)
  end
end
