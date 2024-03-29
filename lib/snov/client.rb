require 'faraday'
require 'multi_json'

module Snov
  class Client
    class SnovError < ::Snov::Error; end

    class TimedOut < SnovError; end

    class AuthError < SnovError; end

    class ResponseError < SnovError
      attr_reader :response

      def initialize(message, response: nil)
        super(message)
        @response = response
      end
    end

    class UnauthorizedError < ResponseError; end

    class BadGatewayError < ResponseError; end

    class OutOfCreditsError < BadGatewayError; end

    class ForbiddenError < ResponseError; end

    class GatewayTimeOut < ResponseError; end

    class BadRequest < ResponseError; end

    class MethodNotAllowed < ResponseError; end

    ERROR_CLASSES = { 401 => UnauthorizedError, 502 => BadGatewayError, 403 => ForbiddenError,
                      504 => GatewayTimeOut, 400 => BadRequest, 405 => MethodNotAllowed }

    def self.select_error_class(resp, fallback: ResponseError)
      if resp&.body.to_s.include?('you ran out of credits')
        OutOfCreditsError
      else
        ERROR_CLASSES.fetch(resp.status, fallback)
      end
    end

    def initialize(client_id:, client_secret:, access_token: nil, timeout_seconds: 90)
      self.client_id = client_id.to_str
      self.client_secret = client_secret.to_str
      @access_token = access_token
      @timeout_seconds = timeout_seconds.to_int
    end

    def get(path, params = {})
      resp = conn.get(path) do |req|
        req.body = MultiJson.dump(params.merge('access_token' => access_token))
        req.options.timeout = timeout_seconds # open/read timeout in seconds
        req.options.open_timeout = timeout_seconds # connection open timeout in seconds
      end
      parse_response(resp, path, params)
    rescue Faraday::TimeoutError, Timeout::Error => e
      raise TimedOut, e.message
    end

    def post(path, params = {})
      resp = conn.post(path) do |req|
        req.body = MultiJson.dump(params.merge('access_token' => access_token))
        req.options.timeout = timeout_seconds # open/read timeout in seconds
        req.options.open_timeout = timeout_seconds # connection open timeout in seconds
      end
      parse_response(resp, path, params)
    rescue Faraday::TimeoutError, Timeout::Error => e
      raise TimedOut, e.message
    end

    private

    def parse_response(resp, path, _params)
      unless resp.success?
        error_class = Client.select_error_class(resp, fallback: ResponseError)
        raise error_class.new("#{path} (#{resp.status})", response: resp&.body)
      end
      MultiJson.load(resp.body.gsub("\u0000", ''))
    end

    attr_accessor :client_id, :client_secret, :timeout_seconds

    def access_token
      if @access_token.nil? || @access_token.fetch("expires_at") < Time.now.to_i + 60
        @access_token = load_access_token
      end
      @access_token.fetch('access_token')
    end

    def access_token_params
      { 'grant_type' => 'client_credentials', 'client_id' => client_id, 'client_secret' => client_secret }
    end

    def load_access_token
      current_access_token = Snov.token_storage&.get || {}
      if current_access_token.fetch("expires_at", 0) < Time.now.to_i + 60
        current_access_token = generate_access_token
        current_access_token['expires_at'] = Time.now.to_i + current_access_token.fetch('expires_in')
        Snov.token_storage&.put(current_access_token)
      end
      current_access_token
    end

    def generate_access_token
      resp = conn.post('/v1/oauth/access_token') do |req|
        req.body = MultiJson.dump(access_token_params)
        req.options.timeout = timeout_seconds # open/read timeout in seconds
        req.options.open_timeout = timeout_seconds # connection open timeout in seconds
      end
      handle_error(resp, "POST /v1/oauth/access_token")
      raise AuthError, 'Snov auth failed' if resp.body.blank?

      MultiJson.load(resp.body)
    rescue Timeout::Error => e
      raise TimedOut, e.message
    end

    def handle_error(resp, prefix)
      return if resp.success?

      raise ERROR_CLASSES.fetch(resp.status, SnovError), "#{prefix} (#{resp.status})"
    end

    def conn
      @conn ||= Faraday.new(
        url: 'https://api.snov.io',
        headers: { 'Content-Type' => 'application/json' }
      )
    end
  end
end
