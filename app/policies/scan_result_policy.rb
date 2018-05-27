class ScanResultPolicy < ApplicationPolicy
  def open_ports?
    index?
  end

  def new_ports?
    index?
  end

  def permitted_attributes
    %i[organization_id
      scan_job_id
      state
      legality
      ip
      port
      protocol
      start
      finished
      service
      product
      product_version
      product_extrainfo]
  end
end
