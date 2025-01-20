module Snov
  class AddNamesToFindEmails
    attr_reader :client

    def initialize(client: Snov.client, first_name:, last_name:, domain:)
      @client = client
      @first_name = first_name
      @last_name = last_name
      @domain = domain
    end

    def add
      @add ||= ProspectResult.new(raw_result)
    end

    def raw_result
      @raw_result ||= client.post("/v1/add-names-to-find-emails",
                                  "firstName" => @first_name,
                                  "lastName" => @last_name,
                                  "domain" => @domain)
    end

    ProspectResult = Class.new(CamelSnakeStruct)
    ProspectResult.example(
      'success' => true,
      'firstName' => "bapu",
      'lastName' => "sethi",
      'domain' => "nexl.io",
      'userId' => 666871,
      'sent' => true
    )
  end
end
