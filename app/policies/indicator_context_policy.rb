class IndicatorContextPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    [:name,
     :codename,
     {indicators_formats: []},
     :description]
  end

  class Scope < Scope
    def resolve
        scope.all
    end
  end
end
