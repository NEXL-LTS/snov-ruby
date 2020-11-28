module Snov
  RSpec.describe GetProfileByEmail do
    subject { described_class.new(client: client, email: "gavin.vanrooyen@octagon.com") }

    let(:client) { instance_double(Client) }

    before do
      json = File.read(__dir__ + "/get_profile_by_email_spec.json")
      allow(client).to receive(:post).with("/v1/get-profile-by-email", "email" => "gavin.vanrooyen@octagon.com")
                                     .and_return(MultiJson.load(json))
    end

    it 'returns all' do
      expect(subject).to have_attributes(name: 'Lizi Hamer')
      expect(subject.social.first).to have_attributes(link: 'https://www.linkedin.com/in/lizihamer/')
    end
  end
end
