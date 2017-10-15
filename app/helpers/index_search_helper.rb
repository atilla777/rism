module IndexSearchHelper
  def index_search(search_fields, options = {})
    render 'helpers/index_search', search_fields: search_fields,
                                   options: options
  end
end
