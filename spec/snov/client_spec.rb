require 'mock_redis'

module Snov
  RSpec.describe Client do
    subject { described_class.new(client_id: "", client_secret: "") }

    context 'without token storage' do
      before do
        stub_request(:post, "https://api.snov.io/v1/oauth/access_token")
          .with(body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"\",\"client_secret\":\"\"}")
          .to_return(status: 200, body: { "access_token" => "example", "expires_in" => 3600 }.to_json)
        Snov.token_storage = nil
      end

      describe "#get" do
        it 'works without params' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"example\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test")

          expect(result).to eq("example" => "result")
        end

        it 'works with params' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"eg\":\"yes\",\"access_token\":\"example\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test", { "eg" => "yes" })

          expect(result).to eq("example" => "result")
        end

        it 'wraps TimeoutError errors' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"eg\":\"yes\",\"access_token\":\"example\"}")
            .and_raise(Faraday::TimeoutError)

          expect { subject.get("/test", { "eg" => "yes" }) }.to raise_error(Client::TimedOut)
        end

        it 'can handle 400 out of credits errors' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"eg\":\"yes\",\"access_token\":\"example\"}")
            .to_return(status: 400,
                       body: { success: false,
                               message: "Sorry, you ran out of credits, please order more credits" }.to_json)

          expect { subject.get("/test", { "eg" => "yes" }) }.to raise_error(Client::OutOfCreditsError)
        end

        it 'can handle 400 errors' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"eg\":\"yes\",\"access_token\":\"example\"}")
            .to_return(status: 400, body: { "errors" => "result" }.to_json)

          expect { subject.get("/test", { "eg" => "yes" }) }.to raise_error(Client::BadRequest)
        end
      end

      describe "#post" do
        it 'works without params' do
          stub_request(:post, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"example\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.post("/test")

          expect(result).to eq("example" => "result")
        end

        it 'works with params' do
          stub_request(:post, "https://api.snov.io/test")
            .with(body: "{\"eg\":\"yes\",\"access_token\":\"example\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.post("/test", { "eg" => "yes" })

          expect(result).to eq("example" => "result")
        end

        it 'wraps TimeoutError errors' do
          stub_request(:post, "https://api.snov.io/test")
            .with(body: "{\"eg\":\"yes\",\"access_token\":\"example\"}")
            .and_raise(Faraday::TimeoutError)

          expect { subject.post("/test", { "eg" => "yes" }) }.to raise_error(Client::TimedOut)
        end

        it 'can handle 400 errors' do
          stub_request(:post, "https://api.snov.io/test")
            .with(body: "{\"eg\":\"yes\",\"access_token\":\"example\"}")
            .to_return(status: 400, body: { "errors" => "result" }.to_json)

          expect { subject.post("/test", { "eg" => "yes" }) }.to raise_error(Client::BadRequest)
        end
      end
    end

    context 'with token storage' do
      context "with unexpired token" do
        before do
          Snov.token_storage = Snov::InMemoryTokenStorage.new("access_token" => "from_storage",
                                                              "expires_at" => Time.now.to_i + 3600)
        end

        it 'uses the stored token' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"from_storage\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test")

          expect(result).to eq("example" => "result")
        end
      end

      context "with expired token" do
        before do
          stub_request(:post, "https://api.snov.io/v1/oauth/access_token")
            .with(body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"\",\"client_secret\":\"\"}")
            .to_return(status: 200, body: { "access_token" => "from_request", "expires_in" => 3600 }.to_json)
          Snov.token_storage = Snov::InMemoryTokenStorage.new("access_token" => "from_storage",
                                                              "expires_at" => Time.now.to_i - 1)
        end

        it 'requests a new token' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"from_request\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test")

          expect(result).to eq("example" => "result")
          expect(Snov.token_storage.get).to include("access_token" => "from_request", "expires_in" => 3600)
          expect(Snov.token_storage.get.keys).to contain_exactly("access_token", "expires_at", "expires_in")
        end
      end

      context "with not previous token" do
        before do
          stub_request(:post, "https://api.snov.io/v1/oauth/access_token")
            .with(body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"\",\"client_secret\":\"\"}")
            .to_return(status: 200, body: { "access_token" => "from_request", "expires_in" => 3600 }.to_json)
          Snov.token_storage = Snov::InMemoryTokenStorage.new
        end

        it 'requests a new token' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"from_request\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test")

          expect(result).to eq("example" => "result")
          expect(Snov.token_storage.get).to include("access_token" => "from_request", "expires_in" => 3600)
          expect(Snov.token_storage.get.keys).to contain_exactly("access_token", "expires_at", "expires_in")
        end
      end
    end

    context 'with redis storage' do
      context "with unexpired token" do
        before do
          Snov.token_storage = Snov::RedisTokenStorage.new(MockRedis.new,
                                                           "access_token" => "from_storage",
                                                           "expires_at" => Time.now.to_i + 3600)
        end

        it 'uses the stored token' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"from_storage\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test")

          expect(result).to eq("example" => "result")
        end
      end

      context "with expired token" do
        before do
          stub_request(:post, "https://api.snov.io/v1/oauth/access_token")
            .with(body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"\",\"client_secret\":\"\"}")
            .to_return(status: 200, body: { "access_token" => "from_request", "expires_in" => 3600 }.to_json)
          Snov.token_storage = Snov::RedisTokenStorage.new(MockRedis.new,
                                                           "access_token" => "from_storage",
                                                           "expires_at" => Time.now.to_i - 1)
        end

        it 'requests a new token' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"from_request\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test")

          expect(result).to eq("example" => "result")
          expect(Snov.token_storage.get).to include("access_token" => "from_request", "expires_in" => 3600)
          expect(Snov.token_storage.get.keys).to contain_exactly("access_token", "expires_at", "expires_in")
        end
      end

      context "with not previous token" do
        before do
          stub_request(:post, "https://api.snov.io/v1/oauth/access_token")
            .with(body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"\",\"client_secret\":\"\"}")
            .to_return(status: 200, body: { "access_token" => "from_request", "expires_in" => 3600 }.to_json)
          Snov.token_storage = Snov::RedisTokenStorage.new(MockRedis.new)
        end

        it 'requests a new token' do
          stub_request(:get, "https://api.snov.io/test")
            .with(body: "{\"access_token\":\"from_request\"}")
            .to_return(status: 200, body: { "example" => "result" }.to_json)

          result = subject.get("/test")

          expect(result).to eq("example" => "result")
          expect(Snov.token_storage.get).to include("access_token" => "from_request", "expires_in" => 3600)
          expect(Snov.token_storage.get.keys).to contain_exactly("access_token", "expires_at", "expires_in")
        end
      end
    end
  end
end
