class LinkPolicy < ApplicationPolicy
  #include RecordPolicy

  def permitted_attributes
    %i[first_record_type
       first_record_id
       second_record_id
       second_record_type
       link_kind_id
       description]
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end
end
