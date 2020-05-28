class HostPolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         to_hosts
         ip
         organization_id
         description]
  end

  def new_import?
    create?
  end

  def create_import?
    create?
  end

  def toggle_readable?
    index?
  end

  def run?
    create?
  end
end
