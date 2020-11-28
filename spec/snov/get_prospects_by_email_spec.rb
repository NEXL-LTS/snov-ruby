module Snov
  RSpec.describe GetProspectsByEmail do
    subject { described_class.new(client: client, email: "gavin.vanrooyen@octagon.com") }

    let(:client) { instance_double(Client) }

    before do
      json = File.read(__dir__ + "/get_prospects_by_email_spec.json")
      allow(client).to receive(:post).with("/v1/get-prospects-by-email", "email" => "gavin.vanrooyen@octagon.com")
                                     .and_return(MultiJson.load(json))
    end

    it 'returns all' do
      result = subject.first
      expect(result).to have_attributes(name: 'Gavin Vanrooyen')
      expect(result.social.first).to have_attributes(link: 'https://www.linkedin.com/in/gavin-vanrooyen-809073755/')
    end
  end
end
