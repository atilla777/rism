# frozen_string_literal: true

module Api
  module V1
    class CustomReportsApiController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      before_action :authenticate

      skip_before_action :set_paper_trail_whodunnit
      skip_before_action :authenticate?
      skip_after_action :verify_authorized

      class Api::V1::ReportFileNotFoundError < StandardError
        def message
          'Custom report file not found. Did report was generated?'
        end
      end

      # Download custom report file throught API.
      # Examples of usage (3 is a custom report ID, afbadb4ff8485c0adcba486b4ca90cc4 is a token example):
      # 1) download as file:
      # curl -OJ -H 'Authorization: Token token=afbadb4ff8485c0adcba486b4ca90cc4' http://localhost:3000/api/v1/custom_reports_api/3
      # 2) show downloaded content in console:
      # curl -H 'Authorization: Token token=afbadb4ff8485c0adcba486b4ca90cc4' http://localhost:3000/api/v1/custom_reports_api/3
      # 3) transfer downloaded content to another app through pipe:
      # curl -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://localhost:3000/api/v1/custom_reports_api/3 | grep some_text
      # If you request data in json format add -H 'Content-Type: application/json' to curl command.
      def show
        @custom_report = custom_report
        raise ReportFileNotFoundError unless authorize @custom_report
        @record = last_result
        check_report_existence
        raise ReportFileNotFoundError unless authorize @record
        format = "text/#{@record.custom_report.result_format}"
        encoding = @record.custom_report.utf_encoding ? 'utf-8' : 'windows-1251'
        send_file(
          @record.result_file_path,
          filename: @record.result_path,
          type: "text/#{format}; charset=#{encoding}",
          disposition: 'attachment',
          x_sendfile: true
        )
      rescue Pundit::NotAuthorizedError
        render_error(error: 'You are not allowed to read this report.', status: :unauthorized, status_code: 401)
      rescue ActiveRecord::RecordNotFound => error
        render_error(error: error, status: :not_found, status_code: 404)
      rescue ReportFileNotFoundError => error
        render_error(error: error.message, status: :internal_server_error, status_code: 500)
      rescue StandardError => error
        render_error(error: error, status: :internal_server_error, status_code: 500)
      end

      private

      def authenticate
        return if authenticate_token
        self.headers["WWW-Authenticate"] = %(Token realm=Application")
        render_error(error: 'Bad credentials', status: :unauthorized, status_code: 401)
      end

      def authenticate_token
        authenticate_with_http_token do |token, options|
          @current_user = User.api_user(token)
        end
      end

      def custom_report
        CustomReport.find(params[:id])
      end

      def last_result
        @custom_report.last_result
      end

      def check_report_existence
        raise ReportFileNotFoundError unless @record
        return if File.exist?(@record.result_file_path)
        raise ReportFileNotFoundError
      end

      def render_error(error:, status:, status_code:)
        render(
          json: {errors: [error], status: status_code},
          status: status
        )
      end
    end
  end
end
