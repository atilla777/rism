# frozen_string_literal: true

class ArticlesFoldersController < ApplicationController
  include RecordOfOrganization

  def select
    authorize model
    @articles_folder = articles_folder
    set_selected_articles
    set_selected_articles_folders
    redirect_back(fallback_location: root_path)
  end

  def reset
    authorize model
    @articles_folder = articles_folder
    session.delete :selected_articles_folders
    session.delete :selected_articles
    redirect_back(fallback_location: root_path)
  end

  def paste
    authorize model
    @articles_folder = articles_folder
    paste_selected_articles
    paste_selected_articles_folders
    redirect_back(fallback_location: root_path)
  end

  def index
    authorize model
    @articles_folder = articles_folder
    scope = if @articles_folder.id
              model.where(parent_id: @articles_folder.id)
            else
              model.where(
                'articles_folders.parent_id IS NULL'
              )
            end
    @records = records(scope)

    @articles = if @articles_folder&.id.present?
                  Pundit.policy_scope(current_user, Article)
                        .where(articles_folder_id: @articles_folder.id)
                        .order(:name)
                else
                  Pundit.policy_scope(current_user, Article)
                        .where(articles_folder_id: nil)
                        .order(:name)
                end
  end

  def show
    @record = record
    authorize @record
    @organization = organization
    @articles_folder = articles_folder
  end

  def new
    @articles_folder = articles_folder
    if @articles_folder.id
      authorize @articles_folder
    else
      authorize ArticlesFolder
    end
    @record = ArticlesFolder.new
    @organization = organization
  end

  def create
    @articles_folder = articles_folder
    if @articles_folder.id
      authorize @articles_folder
    end
    @record = ArticlesFolder.new(record_params)
    authorize @record.class
    @record.current_user = current_user
    @organization = organization
    @record.save!
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      articles_folder_id: @articles_folder.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @record = record
    authorize @record
    @organization = organization
    @articles_folder = articles_folder
  end

  def update
    @record = record
    authorize @record
    @record.current_user = current_user
    @articles_folder = articles_folder
    @record.update!(record_params)
    redirect_to(
      session.delete(:edit_return_to),
      articles_folder_id: @articles_folder.id, success: t(
        'flashes.update', model: model.model_name.human
      )
    )
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @record = model.find(params[:id])
    authorize @record
    @articles_folder = articles_folder
    @organization = organization
    @record.destroy
    redirect_back(
      fallback_location: polymorphic_url(@record.class),
      organization_id: @organization.id,
      articles_folder_id: @articles_folder.id,
      success: t('flashes.destroy', model: model.model_name.human)
    )
  end

  private

  def set_selected_articles
    return unless params[:article_ids]
    session[:selected_articles] ||= []
    session[:selected_articles] += params[:article_ids]
    session[:selected_articles] = session[:selected_articles].uniq
  end

  def set_selected_articles_folders
    return unless params[:articles_folder_ids]
    session[:selected_articles_folders] ||= []
    session[:selected_articles_folders] += params[:articles_folder_ids]
    session[:selected_articles_folders] = session[:selected_articles_folders].uniq
  end

  def paste_selected_articles
    return if session[:selected_articles].blank?
    return unless Pundit.policy(current_user, @articles_folder)&.edit? || current_user.admin_editor?
    articles = Article.where(id: session[:selected_articles].map(&:to_i))
    articles.each do |article|
      next unless Pundit.policy(current_user, article).edit?
      article.update_attributes(
        articles_folder_id: @articles_folder.id,
        current_user: current_user
      )
    end
    session.delete :selected_articles
  end

  def paste_selected_articles_folders
    return if session[:selected_articles_folders].blank?
    return unless Pundit.policy(current_user, @articles_folder)&.edit? || current_user.admin_editor?
    articles_folders = ArticlesFolder.where(
      id: session[:selected_articles_folders].map(&:to_i)
    )
    articles_folders.each do |articles_folder|
      next if articles_folder.id == @articles_folder.id
      next unless Pundit.policy(current_user, articles_folder).edit?
      articles_folder.update_attributes(
        parent_id: @articles_folder.id,
        current_user: current_user
      )
    end
    session.delete :selected_articles_folders
  end

  def articles_folder
    id = if params[:articles_folder_id]
           params[:articles_folder_id]
         elsif params.dig(:articles_folder, :parent_id)
           params[:articles_folder][:parent_id]
         end
    model.where(id: id).first || OpenStruct.new(id: nil)
  end

  def model
    ArticlesFolder
  end

  def default_sort
    ['rank asc', 'name']
  end

  def records_includes
    %i[parent]
  end
end
