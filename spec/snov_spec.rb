RSpec.describe Snov do
  it "has a version number" do
    expect(Snov::VERSION).not_to be nil
  end

  it "returns client" do
    described_class.client
  end
end
