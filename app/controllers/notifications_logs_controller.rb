# frozen_string_literal: true

class NotificationsLogsController < ApplicationController
  def index
    @deliverable = params[:deliverable_type].constantize
      .find(params[:deliverable_id])
    authorize @deliverable
    @notifications = @deliverable.notifications_logs
    render(
      'index',
      layout: false
    )
  end
end
