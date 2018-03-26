class TagPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[name
       tag_kind_id
       rank
       color
       description]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
