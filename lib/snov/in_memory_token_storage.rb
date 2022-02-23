module Snov
  class InMemoryTokenStorage
    def initialize(token = nil)
      @stored_token = token
    end

    def get
      @stored_token
    end

    def put(token_hash)
      @stored_token = token_hash
    end
  end
end
