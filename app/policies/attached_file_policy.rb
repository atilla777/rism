class AttachedFilePolicy < ApplicationPolicy
  def permitted_attributes
    %i[name
       new_name
       filable_type
       fileble_id]
  end
end
