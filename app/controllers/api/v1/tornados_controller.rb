# frozen_string_literal: true

module Api
  module V1
    class TornadosFileNotFoundError < StandardError
      def message
        'Tornados result csv file not found. Did it was generated by background job?'
      end
    end

    class TornadosController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      BASE_FILE_NAME = 'tor_exit_nodes.csv'
      FORMAT = 'text/csv'
      ENCODING = 'utf-8'

      before_action :authenticate

      skip_before_action :set_paper_trail_whodunnit
      skip_before_action :authenticate?
      skip_after_action :verify_authorized

      # Download tor exit nodes file throught API.
      # Examples of usage:
      # 1) download as file:
      # curl -OJ -H 'Authorization: Token token=afbadb4ff8485c0adcba486b4ca90cc4' http://localhost:3000/api/v1/tornados
      # 2) show downloaded content in console:
      # curl -H 'Authorization: Token token=afbadb4ff8485c0adcba486b4ca90cc4' http://localhost:3000/api/v1/tornados
      # 3) transfer downloaded content to another app through pipe:
      # curl -H 'Authorization: Token token="afbadb4ff8485c0adcba486b4ca90cc4"' http://localhost:3000/api/v1/tornados | grep some_text
      
      def show
        raise Pundit::NotAuthorizedError unless authorize :tornados_api
        check_file_existence

        send_file(
          result_file_path,
          filename: filename,
          type: "#{format}; charset=#{encoding}",
          disposition: 'attachment',
          x_sendfile: true
        )
      rescue Pundit::NotAuthorizedError
        render_error(error: 'You are not allowed to read this report.', status: :unauthorized, status_code: 401)
      rescue TornadosFileNotFoundError => error
        render_error(error: error.message, status: :internal_server_error, status_code: 500)
      rescue StandardError => error
        render_error(error: error, status: :internal_server_error, status_code: 500)
      end

      private

      def format
        FORMAT
      end

      def encoding
        ENCODING
      end

      def filename
        @filename ||= "#{BASE_FILE_NAME}_#{Time.now.strftime('%d_%m_%Y-%H_%M')}"
      end

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

      def check_file_existence
        return if File.exist?(result_file_path)

        raise TornadosFileNotFoundError
      end

      def result_file_path
        @result_file_path ||= TornadosService.result_file_path
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
