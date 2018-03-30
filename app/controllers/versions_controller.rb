# frozen_string_literal: true

class VersionsController < ApplicationController
  def index
    authorize :version
    scope = PaperTrail::Version
    @q = scope.ransack(params[:q])
    @q.sorts = 'created_at desc' if @q.sorts.empty?
    @records = @q.result
                 .includes(:item) # TODO: this includes not add any effect
                 .page(params[:page])
  end

  def revert
    version = PaperTrail::Version.find(params[:id])
    current_record = version.item
    record = version.reify
    authorize :version
    authorize current_record
    record.current_user = current_user
    record.save!
    redirect_to(
      polymorphic_url(record),
      success: t('flashes.revert', model: record.class.model_name.human)
    )
  end
end
