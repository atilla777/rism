# frozen_string_literal: true

class UsersActivityReport < BaseReport
  set_lang :ru
  set_report_name :organizations
  set_human_name 'Активность пользователей'
  set_report_model 'UserAction'
  set_required_params %i[]
  set_formats %i[csv]

  def csv(blank_document)
    return '' unless current_user.admin?
    users_actions = UserAction.select('user_actions.user_id').where(created_at: 2.month.ago..Time.zone.now)
      .joins(:user)
      .group('users.name, user_actions.user_id')
      .order('users.name')
    r = blank_document
    header = [
      '№',
      'Пользователь',
      'email',
    ]
    r << header
    users_actions.each_with_index do |user_action, index|
      row = []
      row << index + 1
      row << user_action&.user&.name
      row << user_action&.user&.email
      r << row
    end
  end

  private

  def get_records(_options, _organization);end
end
