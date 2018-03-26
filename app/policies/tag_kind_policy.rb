class TagKindPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[name
       code_name
       record_type
       color
       description]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
