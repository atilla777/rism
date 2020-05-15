class PublicationPolicy < ApplicationPolicy

  def permitted_attributes
    %i[publicable_type
       publicable_id]
  end

  def publicate?
    index?
  end
end
