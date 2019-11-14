# frozen_string_literal: true

# methods that used both in Organizatiable and DefaultAactions
module SharedMethods
  extend ActiveSupport::Concern

  included do
    before_action :set_edit_previous_page, only: %i[index show search]
    before_action :set_show_previous_page, only: %i[index search]
  end

  private

  def record_params
    params.require(model.name.underscore.to_sym)
          .permit(policy(model).permitted_attributes)
  end

  # Show record previous version instead real record if param
  # version_id is set
  def record
    if params[:version_id].present?
      PaperTrail::Version.find(params[:version_id]).reify
    else
      model.find(params[:id])
    end
  end

  # Set Pundit scope, ransack query object and return query result
  def records(scope)
    scope = policy_scope(scope)
    @q = scope.ransack(ransack_params)
    # Reserved to use grouping search conditions
    # @q.build_grouping unless @q.groupings.any?
    @q.sorts = default_sort if @q.sorts.empty?
    @q.result
      .includes(records_includes)
      .page(params[:page])
  end

  def ransack_params
    return prepare_ransack_params if params[:q]

    # Chek case when params is stored as user filter
    return if params[:search_filter_id].blank?
    params[:q] = SearchFilter.find(params[:search_filter_id]).content
  end

  def prepare_ransack_params
    # Make some custom preparation
    custom_prepare_ransack_params

    # Remove head and tail whitespaces
    params[:q].transform_values! do |value|
      if value.is_a?(String)
        value.strip
      else
        value
      end
    end

    # Delete empty values
    params[:q].delete_if do |k, v|
      if v.respond_to?(:all)
        v.all?(&:blank?)
      else
        v.blank?
      end
    end
  end

  # redefine this method in your controller (if needed)
  def custom_prepare_ransack_params; end

  def set_show_previous_page
    session[:show_return_to] = request.original_url
    session[:show_return_to_model] = model.model_name.human count: 2
  end

  def set_edit_previous_page
    session[:edit_return_to] = request.original_url
    count = params[:id].present? ? 1 : 2
    session[:edit_return_to_model] = model.model_name.human count: count
  end

  # set sort field and direction by default
  # (applies when go to index page from other place)
  # it uses ransack, so if you wont to set default sort by
  # associated table field, set it as associated_table_name,
  # (not associated_table.name)
  def default_sort
    'name asc'
  end

  # create new record from template
  def template_attributes
    return if params[:template_id].blank?
    RecordTemplate.find(params[:template_id]).record_content
  end

  def add_from_template
    return if params[:template_id].blank?
    record_template = RecordTemplate.find(params[:template_id])
    add_tags_from_template(record_template)
    add_links_from_template(record_template)
  end

  def add_tags_from_template(record_template)
    record_template.tags.pluck(:id).each do |tag_id|
                    TagMember.create(
                      tag_id: tag_id,
                      record_id: @record.id,
                      record_type: @record.class.name
                    )
    end
  end

  def add_links_from_template(record_template)
    return if params[:template_id].blank?
    record_template.links.each do |link|
                    Link.create(
                      first_record_id: @record.id,
                      first_record_type: @record.class.name,
                      second_record_id: link.second_record_id,
                      second_record_type: link.second_record_type,
                      link_kind_id: link.link_kind_id
                    )
    end
  end
# TODO: use or delete
#  def group_field
#    "#{model.table_name}.id"
#  end
end
