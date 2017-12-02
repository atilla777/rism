class VersionsController < ApplicationController
  def index
    authorize :version
    scope = PaperTrail::Version
    @q = scope.ransack(params[:q])

    @q.sorts = 'rank asc' if @q.sorts.empty?
    @records = @q.result
                 .page(params[:page])
  end

  def revert
    version = PaperTrail::Version.find(params[:id])
    record = version.reify
    authorize :version
    record.save!
    redirect_to polymorphic_url(record), success: t('flashes.revert',
      model: record.class.model_name.human)
  end
end
