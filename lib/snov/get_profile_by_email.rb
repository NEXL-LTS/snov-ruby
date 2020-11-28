require 'active_support/core_ext/array'

module Snov
  class GetProfileByEmail
    attr_reader :client, :email

    def initialize(email:, client: Snov.client)
      @client = client
      @email = email.to_str
    end

    def each(&block)
      prospects.each(&block)
    end

    def prospect
      @prospect ||= ProspectResult.new(raw_result)
    end

    def method_missing(method_name, *arguments, &block)
      if prospect.respond_to?(method_name)
        prospect.public_send(method_name, *arguments, &block)
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      prospect.respond_to?(method_name) || super
    end

    def raw_result
      @raw_result ||= client.post("/v1/get-profile-by-email",
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

      attr_accessor :id, :name, :first_name, :last_name, :industry, :country, :locality, :success, :source
      attr_accessor :logo, :last_update_date, :message
      attr_reader :social, :current_jobs, :previous_jobs

      def social=(val)
        @social = Array.wrap(val).map do |rel|
          Social.new(rel)
        end
      end

      def current_jobs=(val)
        @current_jobs = Array.wrap(val).map do |rel|
          Job.new(rel)
        end
      end

      def previous_jobs=(val)
        @previous_jobs = Array.wrap(val).map do |rel|
          Job.new(rel)
        end
      end
    end
  end
end
