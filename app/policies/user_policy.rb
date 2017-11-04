class UserPolicy < ApplicationPolicy
  def permitted_attributes
    if user.admin?
      %i[name
         organization_id
         email
         phone
         mobile_phone
         job
         active
         password
         password_confirmation
         current_user
         description]
    else
      %i[name
         organization_id
         email
         phone
         mobile_phone
         job
         current_user
         description]
    end
  end
end
