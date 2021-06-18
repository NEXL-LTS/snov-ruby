module Snov
  RSpec.describe GetEmailsFromName do
    subject {
      described_class.new(
        client: client, first_name: first_name, last_name: last_name, domain: domain
      ).prospect
    }

    let(:first_name) { "bapu" }
    let(:last_name) { "sethi" }
    let(:domain) { "nexl.io" }
    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:post).with("/v1/get-emails-from-names",
                                           "firstName" => first_name,
                                           "lastName" => last_name,
                                           "domain" => domain)
                                     .and_return(MultiJson.load(json))
    end

    context 'with sample json' do
      let(:json) { File.read(__dir__ + "/get_emails_from_name_spec.json") }

      it 'has success status' do
        expect(subject).to have_attributes(success: true)
      end

      it 'returns emails' do
        expect(subject.data.emails.first).to have_attributes(email: 'bapu@nexl.io', email_status: 'valid')
      end

      it 'returns prospect status' do
        expect(subject.status).to have_attributes(identifier: 'complete')
      end

      it 'returns prospect status completed?' do
        expect(subject.status.completed?).to be(true)
      end
    end
  end
end
