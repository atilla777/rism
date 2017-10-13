module IndexSearchHelper
  def index_search(search_fields, options = {})
    search_fields = search_fields.join('_or_')
    search_fields << '_cont'
    render 'helpers/index_search', search_fields: search_fields.to_sym,
                                   options: options
  end
end
