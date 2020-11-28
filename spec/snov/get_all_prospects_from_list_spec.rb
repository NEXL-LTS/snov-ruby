module Snov
  RSpec.describe GetAllProspectsFromList do
    subject { described_class.new(client: client, list_id: 2648963, per_page: 1) }

    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:post).with("/v1/prospect-list", "listId" => "2648963", "page" => "1", "perPage" => "1")
                                     .and_return('prospects' => [{ 'name' => 'Petra Staal',
                                                                   'emails' => ['email' => 'petra@staal.nl'] }])
      allow(client).to receive(:post).with("/v1/prospect-list", "listId" => "2648963", "page" => "2", "perPage" => "1")
                                     .and_return('prospects' => [{ 'name' => 'Kelly Yount',
                                                                   'emails' => ['email' => 'kelly@yount.com'] }])
      allow(client).to receive(:post).with("/v1/prospect-list", "listId" => "2648963", "page" => "3", "perPage" => "1")
                                     .and_return('prospects' => [])
    end

    it 'returns all' do
      results = subject.to_a
      expect(results.size).to eq(2)

      result = results.first
      expect(result).to have_attributes(name: 'Petra Staal')
      expect(result.emails.first).to have_attributes(email: 'petra@staal.nl')

      result = results.second
      expect(result).to have_attributes(name: 'Kelly Yount')
      expect(result.emails.first).to have_attributes(email: 'kelly@yount.com')
    end
  end
end
