# frozen_string_literal: true

class LinksController < ApplicationController
  def create
    @link = Link.new(link_params)
    @record = @link.first_record
    authorize Link
    authorize @record
    @link.save
    @unfold_links = true
    @link_kind = @link.link_kind
  end

  def destroy
    @link = Link.find(params[:id])
    @record = @link.first_record
    authorize Link
    authorize @record
    @link.destroy
    @unfold_links = true
    @link_kind = @link.link_kind
  end

  private

  def link_params
    params.permit(policy(Link).permitted_attributes)
  end
end
