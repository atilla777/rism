# frozen_string_literal: true

class Api::CustomReportsController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  #before_action :authenticate

  skip_before_action :set_paper_trail_whodunnit
  skip_before_action :authenticate?
  skip_after_action :log_user_action
  skip_after_action :verify_authorized

  def show
    last_result = set_last_result
    send_file(
      last_result.result_path,
      disposition: 'attachment',
      x_sendfile: true
    )
  end

  private

  def authenticate
    authenticate_token || render_unauthorized
  end

  def authenticate_token
    authenticate_with_http_token do |token, options|
      @current_user = User.find_by(api_key: token)
    end
  end

  def render_unauthorized(realm = "Application")
    self.headers["WWW-Authenticate"] = %(Token realm="#{realm}")
    render json: 'Bad credentials', status: :unauthorized
  end

  def set_last_result
    custom_report = CustomReport.find(params[:id])
    custom_report.last_result
  end
end
