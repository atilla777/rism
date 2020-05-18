class SubscriptionPolicy < ApplicationPolicy

  def permitted_attributes
    %i[user_id
       publicable_type]
  end

  def toggle_subscription?
    create?
  end
end
