module Snov
  class GetEmailsBySocialUrl
    attr_reader :client

    def initialize(client: Snov.client, url:)
      @client = client
      @url = url
    end

    def prospect
      @prospect ||= ProspectResult.new(raw_result)
    rescue ActiveModel::UnknownAttributeError, ArgumentError, NoMethodError => e
      raise InvalidResponseError.new(e.message, response: raw_result)
    end

    def raw_result
      @raw_result ||= client.post("/v1/get-emails-from-url", "url" => @url)
                            .deep_transform_keys! { |key| key.underscore }
    end

    ProspectJob = Class.new(CamelSnakeStruct)

    class ProspectJobList
      include ActiveModel::Model
      include Enumerable

      attr_accessor :jobs

      def each(&block)
        jobs.each(&block)
      end
    end

    class ProspectEmail
      include ActiveModel::Model

      attr_accessor :email, :status
    end

    class ProspectData
      include ActiveModel::Model

      attr_reader :emails, :previous_jobs, :current_jobs
      attr_accessor :id, :name, :first_name, :last_name, :source_page, :source, :industry,
                    :country, :locality, :last_update_date, :social, :skills, :links

      def emails=(val)
        @emails = Array.wrap(val).map do |rel|
          ProspectEmail.new(rel)
        end
      end

      def previous_job=(val)
        @previous_jobs = ProspectJobList.new(jobs: Array.wrap(val).map { |job| ProspectJob.new(job) })
      end

      def current_job=(val)
        @current_jobs = ProspectJobList.new(jobs: Array.wrap(val).map { |job| ProspectJob.new(job) })
      end
    end

    class ProspectResult
      include ActiveModel::Model

      attr_accessor :success, :message
      attr_reader :data

      def data=(val)
        @data = ProspectData.new(val)
      end
    end
  end
end
