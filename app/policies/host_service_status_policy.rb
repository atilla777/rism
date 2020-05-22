# frozen_string_literal: true

class HostServiceStatusPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[name rank description]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
