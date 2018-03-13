class TagKindPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    return unless user.admin_editor?
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
