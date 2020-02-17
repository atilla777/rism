class ProcessingLogPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[processable_type processable_id organization_id]
  end

  def toggle_processed?
    create?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
