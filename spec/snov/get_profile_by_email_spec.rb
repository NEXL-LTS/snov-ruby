module Snov
  RSpec.describe GetProfileByEmail do
    subject { described_class.new(client: client, email: "gavin.vanrooyen@octagon.com") }

    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:post).with("/v1/get-profile-by-email", "email" => "gavin.vanrooyen@octagon.com")
                                     .and_return(MultiJson.load(json))
    end

    context 'with sample json' do
      let(:json) { File.read(__dir__ + "/get_profile_by_email_spec.json") }

      it 'returns all' do
        expect(subject).to have_attributes(name: 'Lizi Hamer')
        expect(subject.social.first).to have_attributes(link: 'https://www.linkedin.com/in/lizihamer/')
        expect(subject.current_jobs).to be_a(Array)
        expect(subject.previous_jobs).to be_a(Array)
      end
    end

    context 'with minimal data' do
      let(:json) { File.read(__dir__ + "/get_profile_by_email_spec_min.json") }

      it 'always returns arrays' do
        expect(subject.social).to be_a(Array)
        expect(subject.current_jobs).to be_a(Array)
        expect(subject.previous_jobs).to be_a(Array)
      end
    end

    context 'when unsuccessful' do
      let(:json) { File.read(__dir__ + "/get_profile_by_email_spec_not_success.json") }

      it 'always returns arrays' do
        expect(subject.result).to eq("We couldn't find profile with this email")
        expect(subject.success).to be(false)
      end
    end
  end
end
