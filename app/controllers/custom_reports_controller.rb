# frozen_string_literal: true

class CustomReportsController < ApplicationController
  include RecordOfOrganization

  before_action :set_folder, only: [:new, :create, :edit, :update, :destroy]

  private

  def set_folder
#    id = if params[:folder_id]
#           params[:folder_id]
#         elsif params.dig(:custom_report, :folder_id)
#           params[:custom_report][:folder_id]
#         end
    id = params[:folder_id] || params.dig(:custom_report, :folder_id)
    @folder = CustomReportsFolder.where(id: id).first || OpenStruct.new(id: nil)
  end

  def model
    CustomReport
  end

  def default_sort
    'created_at desc'
  end

  def records_includes
    %i[organization]
  end
end
