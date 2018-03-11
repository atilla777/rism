# frozen_string_literal: true

class LinksController < ApplicationController
  def create
    @link = Link.new(link_params)
    @record = @link.first_record
    authorize Link
    authorize @record
    @link.save
    @unfold_link = true
  end

  def destroy
    @link = Link.find(params[:id])
    @record = @link.first_record
    authorize Link
    authorize @record
    @link.destroy
    @unfold = true
  end

  private

  def link_params
    params.permit(policy(Link).permitted_attributes)
  end
end
