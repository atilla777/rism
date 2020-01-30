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
      elsif user.can_read_model_index?(scope)
        scope.all
      else
      # TODO: think about it
#        scope.includes(:delivery_list)
#             .where(delivery_lists: {organization_id: user.allowed_organizations_ids(scope)})
        scope.all
      end
    end
  end
end
