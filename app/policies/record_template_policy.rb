class RecordTemplatePolicy < ApplicationPolicy
  include RecordPolicy

  def permitted_attributes
    %i[
      name
      record_content
      description
      record_type
    ]
  end

  class Scope < Scope
    def resolve
        scope.all
    end
  end
end
