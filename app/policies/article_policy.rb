class ArticlePolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         organization_id
         user_id
         content]
  end
end
