# frozen_string_literal: true

class SaveNetworkAsHostsService
  def self.call(*args, &block)
    new(*args, &block).execute
  end

  def initialize(network, name, description, organization_id, current_user)
    @network = network
    @name = name
    @description = description
    @organization_id = organization_id
    @current_user = current_user
  end

  def execute
    ip_list = @network.to_range.to_a
    ip_list[1..-2].each do |ip|
      Host.create!(
        ip: ip.to_s,
        name: @name.present? ? "#{@name} #{ip.to_s}" : '',
        description: @description,
        organization_id: @organization_id,
        current_user: @current_user
      )
    end
    true
  rescue
    false
  end
end
