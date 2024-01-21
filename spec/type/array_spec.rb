require "spec_helper"

RSpec.describe Instructor::Type::Array do
  subject(:array_type) { described_class.new }

  it "has type array" do
    expect(array_type.type).to eq(:array)
  end

  describe "#cast" do
    it "returns the expected values" do
      expect(array_type.cast([1, 2, 3])).to eq([1, 2, 3])
    end

    it "returns an empty array for nil" do
      expect(array_type.cast(nil)).to eq([])
    end

    it "returns an empty array for empty string" do
      expect(array_type.cast("")).to eq([])
    end

    context "when the array values are strings" do
      subject(:array_type) { described_class.new(of: :string) }

      it "returns the expected values" do
        expect(array_type.cast(%w[1 2 3])).to eq(%w[1 2 3])
      end
    end
  end
end
