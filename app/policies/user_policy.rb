class UserPolicy < ApplicationPolicy
  def permitted_attributes(record)
    if user.admin?
      result = %i[name
         organization_id
         email
         phone
         mobile_phone
         job
         active
         password
         password_confirmation
         current_user
         department_id
         department_name
         rank
         description]
    else
      result = %i[name
        organization_id
        email
        phone
        mobile_phone
        job
        current_user
        department_id
        department_name
        rank
        description]
      if @user == record
        result = result + %i[password password_confirmation]
      end
    end
    result
  end

  def change_password?
    @user == record
  end

  def update_password?
    change_password?
  end
end
