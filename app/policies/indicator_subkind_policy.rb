class IndicatorSubkindPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    [:name,
     :codename,
     {indicators_kinds: []},
     :description]
  end

  class Scope < Scope
    def resolve
        scope.all
    end
  end
end
