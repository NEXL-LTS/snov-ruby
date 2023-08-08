RSpec.describe Snov do
  it "has a version number" do
    expect(Snov::VERSION).not_to be_nil
  end

  it "returns client" do
    expect { described_class.client }.not_to raise_error
  end
end
