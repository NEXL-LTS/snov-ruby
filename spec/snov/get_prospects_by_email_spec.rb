module Snov
  RSpec.describe GetProspectsByEmail do
    subject { described_class.new(client: client, email: "gavin.vanrooyen@octagon.com") }

    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:post).with("/v1/get-prospects-by-email", "email" => "gavin.vanrooyen@octagon.com")
                                     .and_return(MultiJson.load(json))
    end

    context 'with sample json' do
      let(:json) { File.read(__dir__ + "/get_prospects_by_email_spec.json") }

      it 'returns all' do
        result = subject.first
        expect(result).to have_attributes(name: 'Gavin Vanrooyen')
        expect(result.social.first).to have_attributes(link: 'https://www.linkedin.com/in/gavin-vanrooyen-809073755/')
        expect(result.current_job.first).to have_attributes(position: 'Senior Brand Director')
      end
    end

    context 'with minimal data' do
      let(:json) { File.read(__dir__ + "/get_prospects_by_email_spec_min.json") }

      it 'always returns arrays' do
        result = subject.first
        expect(result.social).to be_a(Array)
        expect(result.current_job).to be_a(Array)
        expect(result.previous_job).to be_a(Array)
        expect(result.lists).to be_a(Array)
        expect(result.campaigns).to be_a(Array)
      end
    end
  end
end
