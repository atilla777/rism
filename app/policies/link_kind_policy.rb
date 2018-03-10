# frozen_string_literal: true

class LinkKindPolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    if user.admin_editor?
      %i[name
         code_name
         rank
         record_type
         equal
         description]
    end
  end

  class Scope < Scope
    def resolve
        scope.all
    end
  end
end
