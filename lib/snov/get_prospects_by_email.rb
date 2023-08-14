require 'active_support/core_ext/array'
require_relative 'types/date_details'

module Snov
  class GetProspectsByEmail
    include Enumerable

    attr_reader :client, :email

    def initialize(email:, client: Snov.client)
      @client = client
      @email = email.to_str
    end

    def each(&block)
      prospects.each(&block)
    end

    def prospects
      @prospects ||= raw_result.fetch('data', []).map do |result|
        ProspectResult.new(result)
      end
    rescue ActiveModel::UnknownAttributeError, ArgumentError, NoMethodError => e
      raise InvalidResponseError.new(e.message, response: raw_result)
    end

    def raw_result
      @raw_result ||= client.post("/v1/get-prospects-by-email",
                                  'email' => email)
                            .deep_transform_keys! { |key| key.underscore }
    end

    Job = CamelSnakeStruct

    class Social
      include ActiveModel::Model

      attr_accessor :link, :type
    end

    class List
      include ActiveModel::Model

      attr_accessor :id, :name
    end

    class ProspectResult
      include ActiveModel::Model

      attr_accessor :id, :name, :first_name, :last_name, :industry, :country, :locality
      attr_reader :last_update_date

      def social
        Array.wrap(@social)
      end

      def social=(val)
        @social = Array.wrap(val).map do |rel|
          Social.new(rel)
        end
      end

      def current_job
        Array.wrap(@current_job)
      end

      def current_job=(val)
        @current_job = Array.wrap(val).map do |rel|
          Job.new(rel)
        end
      end

      def previous_job
        Array.wrap(@previous_job)
      end

      def previous_job=(val)
        @previous_job = Array.wrap(val).map do |rel|
          Job.new(rel)
        end
      end

      def lists
        Array.wrap(@lists)
      end

      def lists=(val)
        @lists = Array.wrap(val).map do |rel|
          List.new(rel)
        end
      end

      def campaigns
        Array.wrap(@lists)
      end

      def campaigns=(val)
        @campaigns = Array.wrap(val).map do |rel|
          OpenStruct.new(rel)
        end
      end

      def last_update_date=(val)
        @last_update_date = Types::DateDetails.new(val.to_hash)
      end
    end
  end
end
