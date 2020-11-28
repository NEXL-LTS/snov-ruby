require 'active_support/core_ext/array'

module Snov
  class GetProspectList
    include Enumerable

    attr_reader :client, :list_id, :page, :per_page

    def initialize(list_id:, page:, per_page: 100, client: Snov.client)
      @client = client
      @list_id = list_id
      @page = page
      @per_page = per_page
    end

    def each(&block)
      prospects.each(&block)
    end

    def prospects
      @prospects ||= raw_result.fetch('prospects').map do |result|
        ProspectResult.new(result)
      end
    end

    def raw_result
      @raw_result ||= client.post("/v1/prospect-list",
                                  'listId' => list_id.to_s,
                                  'page' => page.to_s,
                                  'perPage' => per_page.to_s)
                            .deep_transform_keys! { |key| key.underscore }
    end

    class ProspectEmail
      include ActiveModel::Model

      attr_accessor :email, :is_verified, :job_status, :domain_type, :is_valid_format
      attr_accessor :is_disposable, :is_webmail, :is_gibberish, :smtp_status, :probability
      attr_accessor :status_type_text, :status_verify_text, :email_verify_text
    end

    class ProspectResult
      include ActiveModel::Model

      attr_accessor :id, :name, :first_name, :last_name, :source
      attr_reader :emails

      def emails=(val)
        @emails = Array.wrap(val).map do |rel|
          ProspectEmail.new(rel)
        end
      end

      def email
        emails.first&.email
      end
    end
  end
end
