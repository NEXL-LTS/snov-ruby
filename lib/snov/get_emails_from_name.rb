module Snov
  class GetEmailsFromName
    attr_reader :client

    InvalidProspectResultError = Class.new(InvalidResponseError)

    def initialize(client: Snov.client, first_name:, last_name:, domain:)
      @client = client
      @first_name = first_name
      @last_name = last_name
      @domain = domain
    end

    def prospect
      @prospect ||= ProspectResult.new(raw_result)
    rescue ArgumentError, NoMethodError => e
      raise InvalidProspectResultError.new(e.message, response: raw_result)
    end

    def raw_result
      @raw_result ||= client.post("/v1/get-emails-from-names",
                                  "firstName" => @first_name,
                                  "lastName" => @last_name,
                                  "domain" => @domain)
                            .deep_transform_keys! { |key| key.underscore }
    end

    ProspectData = Class.new(CamelSnakeStruct)
    ProspectData.example(
      "first_name" => "text",
      "last_name" => "text",
      "domain" => "text",
      "emails" => [{ "email" => "text", "email_status" => "valid" }]
    )

    class ProspectStatus
      include ActiveModel::Model

      attr_accessor :identifier, :description

      def completed?
        identifier == 'complete'
      end

      def in_progress?
        identifier == 'in_progress'
      end

      def not_found?
        identifier == 'not_found'
      end
    end

    class ProspectResult
      include ActiveModel::Model

      attr_accessor :success, :message, :params
      attr_reader :data, :status

      def data=(val)
        @data = ProspectData.new(val)
      end

      def status=(val)
        @status = ProspectStatus.new(val)
      end
    end
  end
end
