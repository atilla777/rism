class DeliveryRecipientPolicy < ApplicationPolicy

  def permitted_attributes
    %i[organization_id
      delivery_list_id]
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
        scope.includes(:delivery_lists)
             .where(delivery_lists: {organization_id: user.allowed_organizations_ids})
      end
    end
  end
end
