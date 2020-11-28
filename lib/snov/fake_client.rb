module Snov
  class FakeClient
    def get(path)
      data = File.read("#{__dir__}/fake_client/get#{path.tr("/", "_")}.json")
      MultiJson.load(data)
    end

    def post(path, params = {})
      params.to_a.map(&:join).join("&")
      data = File.read("#{__dir__}/fake_client/post#{path.tr("/", "_")}.json")
      MultiJson.load(data)
    end
  end
end
