class AgreementKindPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    if user.admin_editor?
      %i[name
         description]
    end
  end

  class Scope < Scope
    def resolve
        scope.all
    end
  end
end
