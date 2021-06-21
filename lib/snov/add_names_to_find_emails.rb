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
                            .deep_transform_keys! { |key| key.underscore }
    end

    class ProspectResult
      include ActiveModel::Model

      attr_accessor :success, :first_name, :last_name, :domain, :user_id, :sent
    end
  end
end
