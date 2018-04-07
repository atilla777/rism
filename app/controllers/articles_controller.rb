# frozen_string_literal: true

class ArticlesController < ApplicationController
  include RecordOfOrganization

#  autocomplete(
#    :article,
#    :name,
#    extra_data: %i[organization_id user_id],
#    display_value: :full_name
#  )
#
#  # authorization for autocomplete
#  def active_record_get_autocomplete_items(parameters)
#    authorize model
#    if current_user.admin_editor?
#      super(parameters)
#      .includes(:organization, :user)
#    else
#      super(parameters)
#      .where(organization_id: current_user.allowed_organizations_ids)
#      .includes(:organization, :user)
#    end
#  end

  def show
    @record = record
    authorize @record
    render 'article' if params[:layout]
  end

  private

  def model
    Article
  end

  def default_sort
    'created_at desc'
  end

  def records_includes
    %i[organization user]
  end
end
