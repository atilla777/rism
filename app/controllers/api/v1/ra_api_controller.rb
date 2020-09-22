# frozen_string_literal: true

module Api
  module V1
    class RaApiController < ApplicationController
      include ActionController::HttpAuthentication::Token::ControllerMethods

      skip_before_action :verify_authenticity_token

      before_action :authenticate

      skip_before_action :set_paper_trail_whodunnit
      skip_before_action :authenticate?
      skip_after_action :verify_authorized

      def create
        puts params
      rescue Pundit::NotAuthorizedError
        render_error(error: 'You are not allowed to read this report.', status: :unauthorized, status_code: 401)
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

      def render_error(error:, status:, status_code:)
        render(
          json: {errors: [error], status: status_code},
          status: status
        )
      end
    end
  end
end
