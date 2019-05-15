class InvestigationKindPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[name description]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
