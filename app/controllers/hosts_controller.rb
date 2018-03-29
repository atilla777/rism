# frozen_string_literal: true

class HostsController < ApplicationController
  include RecordOfOrganization

  # TODO: use or delete
#  autocomplete(
#    :host,
#    :name,
#    extra_data: %i[organization_id],
#    display_value: :show_full_name
#  )

  # authorization for autocomplete
#  def active_record_get_autocomplete_items(parameters)
#    authorize model
#    if current_user.admin_editor?
#      super(parameters)
#      .includes(:organization)
#    else
#      super(parameters)
#      .where(organization_id: current_user.allowed_organizations_ids)
#      .includes(:organization)
#    end
#  end

  private

  def model
    Host
  end

  def default_sort
    'ip desc'
  end

  def records_includes
    %i[organization]
  end
end
