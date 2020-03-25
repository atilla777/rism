class HostServicePolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         port
         protocol
         legality
         organization_id
         host_id
         description
         vulnerable
         vuln_description]
  end

  def run?
    create?
  end
end
