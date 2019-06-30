# frozen_string_literal: true

class SearchFilterPolicy < ApplicationPolicy
  def permitted_attributes
    [
      :name,
      :filtred_model,
      :organization_id,
      :user_id,
      :shared,
      :rank,
      :content,
      :description
    ]
  end

  def destroy?
    return true if @user.admin_editor?
    return false unless @user.can?(:edit, @record)
    @user.id == @record.user_id
  end
end
