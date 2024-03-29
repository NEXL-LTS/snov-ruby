require_relative 'types/date_details'

module Snov
  class GetUserLists
    include Enumerable

    attr_reader :client

    def initialize(client: Snov.client)
      @client = client
    end

    def each(&block)
      all.each(&block)
    end

    def all
      @all ||= raw_result.map { |result| UserList.new(result) }
    rescue ActiveModel::UnknownAttributeError, ArgumentError, NoMethodError => e
      raise InvalidResponseError.new(e.message, response: raw_result)
    end

    def raw_result
      @raw_result ||= client.get("/v1/get-user-lists").map do |val|
        val.deep_transform_keys! { |key| key.underscore }
      end
    end

    class UserList
      include ActiveModel::Model

      attr_accessor :id, :name, :is_deleted, :contacts
      attr_reader :creation_date, :deletion_date

      def creation_date=(val)
        @creation_date = Types::DateDetails.new(val.to_hash)
      end

      def deletion_date=(val)
        @deletion_date = val
        @deletion_date = Types::DateDetails.new(val.to_hash) if val
      end

      def to_h
        { id: id, is_deleted: is_deleted, name: name, contacts: contacts }
      end
    end
  end
end
