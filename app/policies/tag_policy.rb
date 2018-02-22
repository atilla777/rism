class TagPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    return unless user.admin_editor?
    %i[name
       tag_kind_id
       rank
       description]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
