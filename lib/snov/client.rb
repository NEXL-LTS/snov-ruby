require 'faraday'
require 'multi_json'

module Snov
  class Client
    class SnovError < ::Snov::Error; end

    class TimedOut < SnovError; end

    class UnauthorizedError < SnovError; end

    class BadGatewayError < SnovError; end

    class ForbiddenError < SnovError; end

    class GatewayTimeOut < SnovError; end

    class BadRequest < SnovError; end

    class AuthError < SnovError; end

    class MethodNotAllowed < SnovError; end
    ERROR_CLASSES = { 401 => UnauthorizedError, 502 => BadGatewayError, 403 => ForbiddenError,
                      504 => GatewayTimeOut, 400 => BadRequest, 405 => MethodNotAllowed }

    def initialize(client_id:, client_secret:, access_token: nil, timeout_seconds: 60)
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
        raise ERROR_CLASSES.fetch(resp.status, SnovError),
              "#{path} (#{resp.status})"
      end
      MultiJson.load(resp.body)
    end

    attr_accessor :client_id, :client_secret, :timeout_seconds

    def access_token
      return @access_token if @access_token

      @access_token = generate_access_token
    end

    def access_token_params
      { 'grant_type' => 'client_credentials', 'client_id' => client_id, 'client_secret' => client_secret }
    end

    def generate_access_token
      resp = conn.post('/v1/oauth/access_token') do |req|
        req.body = MultiJson.dump(access_token_params)
        req.options.timeout = timeout_seconds # open/read timeout in seconds
        req.options.open_timeout = timeout_seconds # connection open timeout in seconds
      end
      handle_error(resp, "POST /v1/oauth/access_token")
      raise AuthError, 'Snov auth failed' if resp.body.blank?

      MultiJson.load(resp.body).fetch("access_token")
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
