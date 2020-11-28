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
      it 'works' do
        result = subject.post("/v1/prospect-list")

        expect(result).to be_present
      end
    end
  end
end
