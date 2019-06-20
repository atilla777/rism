# frozen_string_literal: true

module AdvancedSearchHelper
  def setup_search_form(builder)
    fields = builder.grouping_fields builder.object.new_grouping,
      object_name: 'new_object_name', child_index: 'new_grouping' do |f|
      render('grouping_fields', f: f)
    end
    content_for :document_ready, %Q{
      var search = new Search({grouping: "#{escape_javascript(fields)}"});
      $(document).on("click", "button.add_fields", function() {
        search.add_fields(this, $(this).data('fieldType'), $(this).data('content'));
        return false;
      });
      $(document).on("click", "button.remove_fields", function() {
        search.remove_fields(this);
        return false;
      });
      $(document).on("click", "button.nest_fields", function() {
        search.nest_fields(this, $(this).data('fieldType'));
        return false;
      });
    }.html_safe
  end

  def button_to_remove_fields
    tag.button 'Remove', class: 'remove_fields btn btn-danger', type: 'button'
  end

  def button_to_add_fields(f, type)
    new_object = f.object.send("build_#{type}")
    name = "#{type}_fields"
    fields = f.send(name, new_object, child_index: "new_#{type}") do |builder|
      render(name, f: builder)
    end

    tag.button button_label[type], class: 'add_fields btn btn-info', 'data-field-type': type,
      'data-content': "#{fields}"
  end

  def button_to_nest_fields(type)
    tag.button button_label[type], class: 'nest_fields btn btn-info', 'data-field-type': type
  end

  def button_label
    { value:     'Add Value',
      condition: 'Add Condition',
      sort:      'Add Sort',
      grouping:  'Add Condition Group' }.freeze
  end

  #TODO: user or delete
  def action
    if action_name == 'advanced_search'
      :post
    else
      :get
    end
  end

  #TODO: user or delete
  def link_to_toggle_search_modes
    if action_name == 'advanced_search'
      link_to('Go to Simple mode', users_path)
    else
      link_to('Go to Advanced mode', advanced_search_users_path)
    end
  end

  #TODO: user or delete
  def user_column_headers
    %i(id first_name last_name email created_at updated_at).freeze
  end

  #TODO: user or delete
  def user_column_fields
    %i(id first_name last_name email created updated).freeze
  end

  #TODO: user or delete
  def results_limit
    # max number of search results to display
    10
  end

  #TODO: user or delete
  def post_title_length
    # max number of characters in posts titles to display
    14
  end

  #TODO: user or delete
  def post_title_header_labels
    %w(1 2 3).freeze
  end

  #TODO: user or delete
  def user_posts_and_comments
    %w(posts comments).freeze
  end

  #TODO: user or delete
  def condition_fields
    %w(fields condition).freeze
  end

  #TODO: user or delete
  def value_fields
    %w(fields value).freeze
  end

  #TODO: user or delete
  def display_distinct_label_and_check_box
    tag.section do
      check_box_tag(:distinct, '1', user_wants_distinct_results?, class: :cbx) +
      label_tag(:distinct, 'Return distinct records')
    end
  end

  #TODO: user or delete
  def user_wants_distinct_results?
    params[:distinct].to_i == 1
  end

  #TODO: user or delete
  def display_query_sql(users)
    tag.p('SQL:') + tag.code(users.to_sql)
  end

  #TODO: user or delete
  def display_results_header(count)
    if count > results_limit
      "Your first #{results_limit} results out of #{count} total"
    else
      "Your #{pluralize(count, 'result')}"
    end
  end

  #TODO: user or delete
  def display_sort_column_headers(search)
    user_column_headers.reduce(String.new) do |string, field|
      string << (tag.th sort_link(search, field, {}, method: action))
    end +
    post_title_header_labels.reduce(String.new) do |str, i|
      str << (tag.th "Post #{i} title")
    end
  end

  #TODO: user or delete
  def display_search_results(objects)
    objects.limit(results_limit).reduce(String.new) do |string, object|
      string << (tag.tr display_search_results_row(object))
    end
  end

  #TODO: user or delete
  def display_search_results_row(object)
    user_column_fields.reduce(String.new) do |string, field|
      string << (tag.td object.send(field))
    end
    .html_safe +
    display_user_posts(object.posts)
  end

  #TODO: user or delete
  def display_user_posts(posts)
    posts.reduce(String.new) do |string, post|
      string << (tag.td truncate(post.title, length: post_title_length))
    end
    .html_safe
  end
end
