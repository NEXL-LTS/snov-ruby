module Snov
  class RedisTokenStorage
    def initialize(redis, token = nil)
      @redis = redis
      put(token) if token
    end

    def get
      result = @redis.get("snov/access_token")
      result = MultiJson.load(result) if result
      result
    end

    def put(token_hash)
      @redis.set("snov/access_token", MultiJson.dump(token_hash))
    end
  end
end
