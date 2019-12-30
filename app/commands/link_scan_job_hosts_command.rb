# frozen_string_literal: true

class LinkScanJobHostsCommand < BaseCommand
  set_command_name :link_scan_jobs_hosts_command
  set_human_name 'Перенести цели сканирования из поля Хосты в связи'
  set_command_model 'ScanJob'
  set_required_params %i[]

  def run
    return unless @current_user.admin?
    scope = ScanJob
    if options[:organization_id].present?
      scope = scope.where(organization_id: options[:organization_id])
    end
    # TODO: use or delete (case when not only admins allowed to run commands)
    # scope = Pundit.policy_scope(current_user, scope)
    scope.all.each do |scan_job|
      move_target(scan_job)
    end
  end

  private

  # move host ip from ScanJob string field to ScanJobsHost link
  def move_target(scan_job)
    scan_job.current_user = current_user
    scan_job.hosts = scan_job.hosts
                    .split(',')
                    .map(&:strip)
                    .reject { |host_ip| link_host?(scan_job, host_ip) }
                    .join(', ')
    scan_job.save
  end

  # make link with ip and return operation status (true | false)
  def link_host?(scan_job, host_ip)
    return false if host_range?(host_ip)
    linked_host = Host.where(ip: host_ip).first
    return false if linked_host.blank?
    return true if link_exist?(scan_job, linked_host)
    return false unless current_user_can_use_host?(linked_host)
    scan_jobs_host = ScanJobsHost.new(scan_job_id: scan_job.id, host_id: linked_host.id)
    scan_jobs_host.save
  end

  # check is it IP address (not range like 192.168.1-2)?
  def host_range?(host_ip)
    ! IPAddr.new("#{host_ip}/32").ipv4?
  rescue StandardError
    true
  end

  def current_user_can_use_host?(linked_host)
    return true if current_user.admin_editor?
    current_user.can?(:edit, linked_host)
  end

  def link_exist?(scan_job, linked_host)
    ScanJobsHost.where(
      scan_job_id: scan_job.id, host_id: linked_host.id
    ).first.present?
  end
end
