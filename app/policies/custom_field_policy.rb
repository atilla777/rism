class CustomFieldPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    [:name,
     :data_type,
     :field_model,
     :description]
  end

  class Scope < Scope
    def resolve
        scope.all
    end
  end
end
