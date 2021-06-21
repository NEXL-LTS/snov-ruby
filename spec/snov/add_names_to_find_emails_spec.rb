module Snov
  RSpec.describe AddNamesToFindEmails do
    subject {
      described_class.new(
        client: client, first_name: first_name, last_name: last_name, domain: domain
      ).add
    }

    let(:first_name) { "bapu" }
    let(:last_name) { "sethi" }
    let(:domain) { "nexl.io" }
    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:post).with("/v1/add-names-to-find-emails",
                                           "firstName" => first_name,
                                           "lastName" => last_name,
                                           "domain" => domain)
                                     .and_return(MultiJson.load(json))
    end

    context 'with sample json' do
      let(:json) { File.read(__dir__ + "/add_names_to_find_emails_spec.json") }

      it 'has success sent' do
        expect(subject).to have_attributes(
          success: true,
          first_name: 'bapu',
          last_name: 'sethi',
          domain: 'nexl.io',
          user_id: 666871,
          sent: true
        )
      end
    end
  end
end
