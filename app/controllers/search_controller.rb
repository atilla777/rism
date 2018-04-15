class SearchController < ApplicationController
  def index
    @records = PgSearch.multisearch(params[:words]).page(params[:page])
  end
end
