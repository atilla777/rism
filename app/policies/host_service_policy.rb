class HostServicePolicy < ApplicationPolicy
  def permitted_attributes
      %i[name
         port
         protocol
         host_service_status_id
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
