class ProcessinglogPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[processable_type processable_id organization_id]
  end

#  def toggle_processed?
#    return true if @user.admin_editor?
#    @user.can? :read, @record
#  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
