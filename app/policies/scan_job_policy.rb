class ScanJobPolicy < ApplicationPolicy
  def permitted_attributes
    %i[name
       organization_id
       scan_engine
       scan_option_id
       hosts
       ports
       description]
  end

  def run?
    new?
  end
end
