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
    end

    def raw_result
      @raw_result ||= client.post("/v1/get-prospects-by-email",
                                  'email' => email)
                            .deep_transform_keys! { |key| key.underscore }
    end

    class Job
      include ActiveModel::Model

      attr_accessor :company_name, :position, :social_link, :site, :locality, :state, :city
      attr_accessor :street, :street2, :postal, :founded, :start_date, :end_date, :size
      attr_accessor :industry, :company_type, :country
    end

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
      attr_reader :social

      def social=(val)
        @social = Array.wrap(val).map do |rel|
          Social.new(rel)
        end
      end

      def current_job=(val)
        @current_job = Array.wrap(val).map do |rel|
          Job.new(rel)
        end
      end

      def previous_job=(val)
        @previous_job = Array.wrap(val).map do |rel|
          Job.new(rel)
        end
      end

      def lists=(val)
        @lists = Array.wrap(val).map do |rel|
          List.new(rel)
        end
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
