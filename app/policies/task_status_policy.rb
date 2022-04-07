# frozen_string_literal: true

class TaskStatusPolicy < ApplicationPolicy
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
