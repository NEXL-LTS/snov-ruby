module Snov
  class GetAllProspectsFromList
    include Enumerable

    attr_reader :client, :list_id, :max, :per_page

    def initialize(list_id:, max: 9999, per_page: 100, client: Snov.client)
      @client = client
      @list_id = list_id
      @max = max.to_int
      @per_page = per_page
    end

    def each(&block)
      (1..max).each do |page|
        list = GetProspectList.new(list_id: list_id, page: page, per_page: per_page,
                                   client: client)
        prospects = list.prospects

        prospects.each(&block)

        break if prospects.size < per_page
      end
    end
  end
end
