class DeliverySubjectPolicy < ApplicationPolicy

  def permitted_attributes
    %i[deliverable_type
      deliverable_id
      recipient_comment
      processed
      delivery_list_id]
  end

  def toggle_processed?
    index?
  end

#  def set_readable?
#    index?
#  end

  def toggle_readable?
    index?
  end

  def notify?
    create?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin_editor_reader?
        scope.all
      elsif user.can_read_model_index?(scope) # can user read delivery_subject model?
        allowed_models = user.allowed_models
        scope.where(deliverable_type: allowed_models) # can user read models that was delivered?
      else
        scope.none
      end
    end
  end
end
