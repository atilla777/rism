# frozen_string_literal: true

module FolderRecord
  extend ActiveSupport::Concern

  included do
    before_action :set_folder_model, only: %i[index]
  end

  def paste
    @folder = folder
    if folder.id
      authorize @folder
    else
      authorize model
    end
    paste_selected_records
    paste_selected_folders
    redirect_back(fallback_location: root_path)
  end

  private

  def paste_selected_folders
    ids = session.fetch(:selected, {}).fetch(model.model_name.to_s, []).map(&:to_i)
    model.where(id: ids).each do |f|
        next if f.id == @folder.id
        next unless Pundit.policy(current_user, f).edit?
        f.update_attributes(
          parent_id: @folder.id,
          current_user: current_user
        )
      end
    session[:selected].delete(model.model_name.to_s)
  end

  def paste_selected_records
    ids = session.fetch(:selected, {}).fetch(records_model.model_name.to_s, [])
    records_model.where(id: ids).each do |r|
      next if r.folder_id == @folder.id
      next unless Pundit.policy(current_user, r).edit?
      r.update_attributes(
        folder_id: @folder.id,
        current_user: current_user
      )
    end
    session[:selected].delete(records_model.model_name.to_s)
  end
end
