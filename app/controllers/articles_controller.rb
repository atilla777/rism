# frozen_string_literal: true

class ArticlesController < ApplicationController
  include RecordOfOrganization
  include SubscribaleRecord
  include PublicableRecord

  before_action :set_id_for_uploader, only: [:edit]
  after_action :reset_id_for_uploader, only: [:update]

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

  def index
    authorize model
    @organization = organization
    @records = records(model)
  end

  def create
    articles_folder = ArticlesFolder.where(id: params[:articles_folder_id]).first
    if articles_folder.present?
      authorize(articles_folder, :show?)
      organization = articles_folder.organization
    else
      organization = current_user.organization
    end
    @record = model.new(
      name: "New article #{SecureRandom.uuid}",
      articles_folder_id: articles_folder&.id,
      organization_id: organization.id,
      current_user: current_user,
      user: current_user
    )
    authorize @record.class
    @record.save!
    add_from_template
    redirect_back(fallback_location: root_path)
  rescue ActiveRecord::RecordInvalid
    # TODO: Add falsh message
  end

  private

  def model
    Article
  end

  def default_sort
    'created_at desc'
  end

  def records_includes
    %i[organization user publication]
  end

  def set_id_for_uploader
    session[:editable_article_id] = params[:id]
  end

  def reset_id_for_uploader
    session[:editable_article_id] = nil
  end
end
