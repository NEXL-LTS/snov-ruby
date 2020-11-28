module Snov
  RSpec.describe FakeClient do
    subject { described_class.new }

    describe "#get" do
      it 'works' do
        result = subject.get("/v1/get-user-lists")

        expect(result).to be_present
      end
    end

    describe "#post" do
      it 'when /v1/prospect-list' do
        result = subject.post("/v1/prospect-list")

        expect(result).to be_present
      end

      it 'when /v1/get-prospects-by-email' do
        result = subject.post("/v1/get-prospects-by-email")

        expect(result).to be_present
      end
    end
  end
end
