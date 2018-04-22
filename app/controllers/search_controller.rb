class SearchController < ApplicationController
  def index
    @records = PgSearch.multisearch(params[:words])
                       .with_pg_search_highlight
                       .page(params[:page])
  end
end
