# frozen_string_literal: true

class Api::CustomReportsApiController < ApplicationController
  include ActionController::HttpAuthentication::Token::ControllerMethods

  before_action :authenticate

  skip_before_action :set_paper_trail_whodunnit
  skip_before_action :authenticate?
  #skip_after_action :log_user_action
  skip_after_action :verify_authorized

  # Download custom report file throught API.
  # Examles of usage (3 is a custom report ID, afbadb4ff8485c0adcba486b4ca90cc4 is a token example):
  # download as file -
  # curl -O -J -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://localhost:3000/api/custom_reports_api/3
  # show downloaded content in console -
  # curl -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://localhost:3000/api/custom_reports_api/3
  # transfer downloaded content to another app through pipe -
  # curl -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://localhost:3000/api/custom_reports_api/3 | grep some_text
  def show
    # TODO: add error output
    @record = set_last_result
    send_file(
      @record.result_file_path,
      filename: @record.result_path,
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
      @current_user = User.api_user(token)
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
