# frozen_string_literal: true

class TaskPriorityPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[name rank]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
