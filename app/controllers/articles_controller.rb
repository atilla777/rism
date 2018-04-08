# frozen_string_literal: true

class ArticlesController < ApplicationController
  include RecordOfOrganization

  def autocomplete_article_name
    authorize model
    scope = if current_user.admin_editor?
              Article
            elsif current_user.can_read_model_index? Organization
              Article
            else
              Article.where(
                id: current_user.allowed_organizations_ids
              )
            end

    term = params[:term]
    records = scope.select(:id, :name)
                       .where('name ILIKE ? OR id::text LIKE ?', "%#{term}%", "#{term}%")
                       .order(:id)
    result = records.map do |record|
               {
                 id: record.id,
                 name: record.name,
                 :value => record.name
               }
             end
    render json: result
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
