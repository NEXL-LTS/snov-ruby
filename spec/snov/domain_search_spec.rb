module Snov
  RSpec.describe DomainSearch do
    subject { described_class.new(client: client, domain: "octagon.com", type: "personal", limit: 10) }

    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:get).with("/v2/domain-emails-with-info",
                                          "type" => "personal", "limit" => 10,
                                          "domain" => 'octagon.com', "lastId" => 0)
                                    .and_return(
                                      "success" => true,
                                      "domain" => "octagon.com",
                                      "webmail" => false,
                                      "result" => 84,
                                      "lastId" => 1823487525,
                                      "limit" => 100,
                                      "companyName" => "Octagon",
                                      "emails" => [
                                        {
                                          "email" => "ben.gillespie@octagon.com",
                                          "firstName" => "Ben",
                                          "lastName" => "Gillespie",
                                          "position" => "Senior Account Executive",
                                          "sourcePage" => "https://www.linkedin.com/pub/ben-gillespie/7/73/809",
                                          "companyName" => "Octagon",
                                          "type" => "prospect",
                                          "status" => "verified"
                                        }
                                      ]
                                    )
    end

    it 'returns all' do
      result = subject.first
      expect(result).to have_attributes(first_name: 'Ben', last_name: 'Gillespie')
      expect(subject).to have_attributes(success: true, domain: 'octagon.com',
                                         webmail: false, result: 84,
                                         last_id: 1823487525, limit: 10,
                                         company_name: 'Octagon')
      expect(subject.to_a).to be_a(Array)
      expect(subject.to_h).to be_a(Hash)
    end
  end
end
