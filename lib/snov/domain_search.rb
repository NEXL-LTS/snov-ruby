require 'active_support/core_ext/array'
require 'camel_snake_struct'

module Snov
  class DomainSearch
    Response = Class.new(CamelSnakeStruct)
    include Enumerable

    attr_reader :client, :domain, :type, :limit

    def initialize(domain:, type: 'all', limit: 10, last_id: 0, client: Snov.client)
      @client = client
      @domain = domain
      @type = type
      @limit = limit
      @last_id = last_id
    end

    def each(&block)
      raw_result.emails.each(&block)
    end

    def success
      raw_result.success
    end

    def webmail
      raw_result.webmail
    end

    def result
      raw_result.result
    end

    def last_id
      raw_result.last_id
    end

    def company_name
      raw_result.company_name
    end

    def raw_result
      Response.new(client.post("/v2/domain-emails-with-info",
                               'lastId' => @last_id,
                               'limit' => @limit,
                               'type' => type.to_s,
                               'domain' => domain.to_s))
    end
  end
end
