class ScanResultPolicy < ApplicationPolicy
  def open_ports?
    index?
  end

  def new_ports?
    index?
  end

  def run?
    create?
  end

  def search?
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
      product_extrainfo
      vulns
      jid]
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.admin_editor_reader?
        scope.all
      elsif user.can_read_model_index?(scope)
        scope.all
      else
        scope.joins(:scan_job)
          .merge(
            ScanJob.where(organization_id: user.allowed_organizations_ids('ScanJob'))
          )
      end
    end
  end
end
