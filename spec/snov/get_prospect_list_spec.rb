module Snov
  RSpec.describe GetProspectList do
    subject { described_class.new(client: client, list_id: 747828, page: 1) }

    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:post).with("/v1/prospect-list", "listId" => "747828", "page" => "1", "perPage" => "100")
                                     .and_return('prospects' => [{ 'name' => 'Kelly Yount',
                                                                   'emails' => ['email' => 'kelly@yount.com'] }])
    end

    it 'returns all' do
      result = subject.first
      expect(result).to have_attributes(name: 'Kelly Yount')
      expect(result.emails.first).to have_attributes(email: 'kelly@yount.com')
    end
  end
end
