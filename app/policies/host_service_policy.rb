class HostServicePolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         port
         protocol
         host_service_status_id
         host_service_status_prop
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
