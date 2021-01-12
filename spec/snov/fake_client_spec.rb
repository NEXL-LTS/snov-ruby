module Snov
  RSpec.describe FakeClient do
    it 'works for /v1/get-profile-by-email' do
      data = subject.post("/v1/get-profile-by-email", { email: "lizi.hamer@octagon.com" })
      expect(data).to include("success" => true, "id" => 301592, "source" => "linkedIn",
                              "name" => "Lizi Hamer", "firstName" => "Lizi", "lastName" => "Hamer",
                              "logo" => "https://app.snov.io/img/peoples/010fcf23c70dfa68d880545ec89a9215.jpg",
                              "industry" => nil, "country" => "Singapore", "locality" => "Singapore")
    end

    it 'works for /v1/get-profile-by-email that do not exist' do
      data = subject.post("/v1/get-profile-by-email", { email: "some.one@octagon.com" })
      expect(data).to eq("success" => true, "message" => "We couldn't find profile with this email")
    end

    it 'works for /v2/domain-emails-with-info' do
      data = subject.get("/v2/domain-emails-with-info", { domain: "octagon.com" })
      expect(data).to include("success" => true, "domain" => "octagon.com",
                              "webmail" => false, "result" => 84,
                              "lastId" => 1823487525, "limit" => 100,
                              "companyName" => "Octagon")
    end

    it 'works for /v2/domain-emails-with-info that do not exist' do
      data = subject.get("/v2/domain-emails-with-info", { domain: "no-one-here-please.com" })
      expect(data).to include("companyName" => "", "domain" => "", "emails" => [], "lastId" => 0,
                              "limit" => 10, "result" => 0, "success" => true, "webmail" => false)
    end

    it 'works for /v1/get-prospects-by-email' do
      data = subject.post("/v1/get-prospects-by-email", { email: "gavin.vanrooyen@octagon.com" })
      expect(data['data'].first).to include("id" => "xusD3-T_K5IktGoaa8Jc8A==",
                                            "name" => "Gavin Vanrooyen")
    end

    it 'works for /v1/get-prospects-by-email that do not exist' do
      data = subject.post("/v1/get-prospects-by-email", { email: "no.one.home@octagon.com" })
      expect(data).to include("success" => false,
                              "errors" => "Prospect with email 'no.one.home@octagon.com' not found")
    end

    it 'works for /v1/get-user-lists' do
      data = subject.get("/v1/get-user-lists")
      expect(data.first).to include("id" => 1818597,
                                    "name" => "FirstSend",
                                    "contacts" => 1,
                                    "isDeleted" => false)
    end

    it 'works for /v1/prospect-list' do
      data = subject.post("/v1/prospect-list", { listId: 1818597, page: 1, perPage: 100 })
      expect(data['prospects'].first).to include("name" => "Andrew Garfiled")
    end

    it 'works for /v1/prospect-list that does not exist' do
      expect {
        subject.post("/v1/prospect-list", { listId: 0, page: 1, perPage: 100 })
      }.to raise_error(Snov::Client::BadRequest)
    end

    it 'can change folder' do
      described_class.folder = "#{__dir__}/moved"
    end
  end
end
