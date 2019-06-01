class DeliveryListPolicy < ApplicationPolicy
  def permitted_attributes
    %i[name
       organization_id
       description]
  end
end
