# frozen_string_literal: true

class CustomReportsFoldersController < ApplicationController
  include RecordOfOrganization
  include FolderRecord

  def index
    authorize model
    @folder = folder
    scope = if @folder.id
              model.where(parent_id: @folder.id)
            else
              model.where(
                'custom_reports_folders.parent_id IS NULL'
              )
            end
    @folders = records(scope)

    @records = if @folder&.id.present?
                  Pundit.policy_scope(current_user, CustomReport)
                        .where(folder_id: @folder.id)
                        .order(:name)
                else
                  Pundit.policy_scope(current_user, CustomReport)
                        .where(folder_id: nil)
                        .order(:name)
                end
  end

  def show
    @record = record
    authorize @record
    @organization = organization
    @folder = folder
  end

  def new
    @folder = folder
    if @folder.id
      authorize @folder
    else
      authorize CustomReportsFolder
    end
    @record = CustomReportsFolder.new
    @organization = organization
  end

  def create
    @folder = folder
    if @folder.id
      authorize @folder
    end
    @record = CustomReportsFolder.new(record_params)
    authorize @record.class
    @record.current_user = current_user
    @organization = organization
    @record.save!
    redirect_to(
      session.delete(:edit_return_to),
      organization_id: @organization.id,
      folder_id: @folder.id,
      success: t('flashes.create', model: model.model_name.human)
    )
  rescue ActiveRecord::RecordInvalid
    render :new
  end

  def edit
    @record = record
    authorize @record
    @organization = organization
    @folder = folder
  end

  def update
    @record = record
    authorize @record
    @record.current_user = current_user
    @folder = folder
    @record.update!(record_params)
    redirect_to(
      session.delete(:edit_return_to),
      articles_folder_id: @folder.id, success: t(
        'flashes.update', model: model.model_name.human
      )
    )
  rescue ActiveRecord::RecordInvalid
    render :edit
  end

  def destroy
    @record = model.find(params[:id])
    authorize @record
    @folder = folder
    @organization = organization
    @record.destroy
    redirect_back(
      fallback_location: polymorphic_url(@record.class),
      organization_id: @organization.id,
      articles_folder_id: @folder.id,
      success: t('flashes.destroy', model: model.model_name.human)
    )
  end

  private

  def folder
    id = if params[:folder_id]
           params[:folder_id]
         elsif params.dig(:custom_reports_folder, :parent_id)
           params[:custom_reports_folder][:parent_id]
         end
    model.where(id: id).first || OpenStruct.new(id: nil)
  end

  def model
    CustomReportsFolder
  end

  def records_model
    CustomReport
  end

  def set_folder_model
    @folder_model = model
  end

  def default_sort
    ['rank asc', 'name']
  end

  def records_includes
    %i[parent]
  end
end
