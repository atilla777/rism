class TagMemberPolicy < ApplicationPolicy
  #include RecordPolicy

  def permitted_attributes
    %i[record_type
       record_id
       tag_id]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
