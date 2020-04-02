# frozen_string_literal: true

module Api
  module V1

    class RoutingErrorController < ActionController::Base
      def show
        render(
          json: {errors: 'Page (resource) not found.', status: 400},
          status: :bad_request
        )
      end
    end

  end
end
