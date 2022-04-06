# frozen_string_literal: true

class FiltredTableTasksReport < BaseReport
  include DateTimeHelper

  set_lang :ru
  set_report_name :filtred_table_tasks
  set_human_name 'Результаты поиска по полям'
  set_report_model 'Task'
  set_required_params %i[q]
  set_formats %i[csv]

  def csv(blank_document)
    r = blank_document

    header = [
        '№',
        'ID',
        'Название',
        'Тэги',
        'Родительская задача',
        'Дочерние задачи',
        'Исполнитель',
        'Статус',
        'Приоритет',
        'Начало',
        'Плановое окончание',
        'Окончание',
        'Описание',
        'Текущее состояние',
        'Заметки исполнителя',
        'Комментарии',
        'Организация',
        'Cоздал',
        'Время создания',
        'Отредактировал',
        'Время редактирования'
    ]

    r << header

    @records.each_with_index do |record, index|
      row = []
      record = TaskDecorator.new(record)

      row << index + 1
      row << record.id
      row << record.name
      row << record.task_tags.join("\n")
      row << record.show_parent_with_status_and_id
      row << record.children.each_with_object([]) do |c, acc|
          acc << TaskDecorator.new(c).show_name_with_status_and_id
      end.join("\n")
      row << record.user.name
      row << record.task_status.name
      row << record.task_priority.name
      row << show_date_time(record.start)
      row << show_date_time(record.planned_end)
      row << show_date_time(record.real_end)
      row << record.description
      row << record.current_description
      row << record.user_description
      row << comments_tree(record.comments)
      row << record.organization.name
      row << record.creator.name
      row << show_date_time(record.created_at)
      row << record.updater&.name
      row << show_date_time(record.updated_at)

      r << row
    end
  end

  private

  def get_records(options, organization)
    scope = Pundit.policy_scope(current_user, Task)
      .includes(
        :organization,
        :user,
        :creator,
        :updater,
        :task_status,
        :task_priority
      )
    if options[:q].present?
      q = scope.ransack(options[:q])
      q.sorts = options[:q].fetch('s', default_sort)
      q.result.limit(2000)
    else
      scope.all.limit(2000).sort(default_sort)
    end
  end

  def default_sort
    'created_at desc'
  end
  
  def comments_tree(parent_comments, tab = '')
    return '' if parent_comments.blank?

    result = CommentDecorator.wrap(parent_comments).each_with_object([]) do |pc, acc|
      comment_str = "#{tab}#{pc.show_header}: #{pc.content.gsub("\n", ' ')}\n"
      children_comments_str = comments_tree(pc.children, "#{tab}  ")
      acc << "#{comment_str}#{children_comments_str}"
    end.compact.join('')
  end
end
