module Snov
  RSpec.describe GetUserLists do
    subject { described_class.new(client: client) }

    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:get).and_return([{
                                                  "id" => 1818597, "name" => "FirstSend",
                                                  "contacts" => 1,
                                                  "isDeleted" => false,
                                                  "creationDate" => {
                                                    "date" => "2020-04-07 08:25:44.000000",
                                                    "timezone_type" => 3,
                                                    "timezone" => "UTC"
                                                  },
                                                  "deletionDate" => nil
                                                }])
    end

    it 'returns all lists' do
      list = subject.find { |result| result.id == 1818597 }
      expect(list).to have_attributes(is_deleted: false,
                                      name: 'FirstSend',
                                      contacts: 1)
    end
  end
end
