module Snov
  RSpec.describe Client do
    subject { described_class.new(client_id: "", client_secret: "") }

    before do
      stub_request(:post, "https://api.snov.io/v1/oauth/access_token")
        .with(body: "{\"grant_type\":\"client_credentials\",\"client_id\":\"\",\"client_secret\":\"\"}")
        .to_return(status: 200, body: { "access_token" => "example" }.to_json)
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
    end
  end
end
