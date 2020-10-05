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

      class RaDataError < StandardError; end

      def create
        raise Pundit::NotAuthorizedError unless authorize :ra_agent_api
        authorize :ra_agent_api
        @jid = params['jid']
        @externalip = params['externalip']
        @result = params
        unless @result['hosts'].present?
          raise RaDataError.new('Ra return data without hosts.')
        end
        @job_log = ScanJobLog.where(jid: @jid).first
        unless @job_log.present?
          raise RaDataError.new('Job log record not found.')
        end
        @job = @job_log.scan_job
        unless @job.present?
          raise RaDataError.new('Job record not found.')
        end
        @job_start = @job_log.start
        @admin = User.find(1)
        save_result
        unless ScanJobLog.log(:finish, @job.id, @jid) 
          raise RaDataError.new('Scan job log can`t be saved.')
        end
        render json: {message: 'accepted'}.to_json
       rescue RaDataError => e
         render_error(error: e.message, status: :not_acceptable, status_code: 406)
       rescue Pundit::NotAuthorizedError
         render_error(error: 'You are not allowed to use this API.', status: :unauthorized, status_code: 401)
       rescue StandardError => error
         render_error(error: error, status: :internal_server_error, status_code: 500)
      end

      private

      def save_result
        @result['hosts'].each do |host|
          if host['ports'].present?
            host['ports'].each do |port|
              save_port_result(host, port)
            end
          else
            save_empty_host_result(host)
          end
        end
      end

      def save_port_result(host, port)
        attributes = scan_result_attributes(host, port)
        legality = HostService.legality(
          attributes[:ip],
          attributes[:port],
          attributes[:protocol],
          attributes[:state]
        )
        save_result_to_database(attributes.merge(legality: legality))
      end

      def save_empty_host_result(host)
        attributes = scan_result_empty_attributes(host)
        save_result_to_database(attributes)
      end

      def save_result_to_database(attributes)
        ScanResult.create(
          attributes.merge(
            current_user: @admin
          )
        ).save!
      end

      def scan_result_attributes(host, port)
        {
          job_start: @job_start,
          start: Time.at(host['starttime']).to_datetime,
          finished: Time.at(host['endtime']).to_datetime,
          scan_job_id: @job.id,
          ip: host_ip(host),
          port: port['id'],
          protocol: port['protocol'],
          state: ScanResult.nmap_to_rism_port_state(port.dig('state', 'state')),
          service: port.dig('service', 'name'),
          product: port.dig('service', 'product'),
          product_version: port.dig('service', 'version'),
          product_extrainfo: port.dig('service', 'extrainfo'),
          jid: @jid,
          source_ip: @externalip
        }
      end

      def scan_result_empty_attributes(host)
        {
          job_start: @job_start,
          start: Time.at(host['starttime']).to_datetime,
          finished: Time.at(host['endtime']).to_datetime,
          scan_job_id: @job.id,
          ip: host_ip(host),
          port: 0,
          protocol: '',
          state: 0,
          legality: :no_sense,
          service: '',
          product: '',
          product_version: '',
          product_extrainfo: '',
          vulners: [],
          jid: @jid,
          source_ip: @externalip
        }
      end

      def host_ip(host)
        addr = host['addresses'].find do |address|
          address['addrtype'] == 'ipv4'
        end
        addr['addr']
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

      def render_error(error:, status:, status_code:)
        render(
          json: {errors: [error], status: status_code},
          status: status
        )
      end
    end
  end
end
