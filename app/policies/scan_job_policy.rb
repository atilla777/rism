class ScanJobPolicy < ApplicationPolicy
  def permitted_attributes
    %i[name
       organization_id
       scan_engine
       scan_option_id
       agent_id
       hosts
       ports
       description
       add_organization_hosts]
  end

  def run?
    create?
  end
end
