module Snov
  RSpec.describe GetEmailsBySocialUrl do
    subject { described_class.new(client: client, url: social_url).prospect }

    let(:social_url) { "https://www.linkedin.com/in/john-doe-123456/" }
    let(:client) { instance_double(Client) }

    before do
      allow(client).to receive(:post).with("/v1/get-emails-from-url", "url" => social_url)
                                     .and_return(MultiJson.load(json))
    end

    context 'with sample json' do
      let(:json) { File.read(__dir__ + "/get_emails_by_social_url_spec.json") }

      it 'has success status' do
        expect(subject).to have_attributes(success: true)
      end

      it 'returns emails' do
        expect(subject.data.emails.first).to have_attributes(email: 'johndoe@octagon.com', status: 'valid')
      end

      it 'returns previous job' do
        expect(subject.data.previous_jobs.first).to have_attributes(
          "city" => "Atlanta",
          "company_name" => "UPS",
          "company_type" => "Public Company",
          "country" => "United States",
          "state" => "GA",
          "street" => "55 Glenlake Parkway, NE"
        )
      end

      it 'returns current job job' do
        expect(subject.data.current_jobs.first).to have_attributes(
          "company_name" => "Octagon",
          "company_type" => "Public Company",
          "position" => "Senior Brand Director",
          "country" => "United States",
          "locality" => "United States",
          "start_date" => "2018-07-31",
          "size" => "1-10",
          "industry" => "Entertainment"
        )
      end
    end
  end
end
