# frozen_string_literal: true

module SearchFilterable
  extend ActiveSupport::Concern

  included do
    before_action :set_search_filters, only: %i[index search]
    before_action :set_search_filter, only: %i[index search]
  end

  private

  def set_search_filters
    # SearchFilter.where(shared: true).all
    @search_filters = current_user.search_filters_for(model)
      .includes(:user)
      .order(rank: :asc)
  end

  def set_search_filter
    @search_filter = SearchFilter.new
  end
end
