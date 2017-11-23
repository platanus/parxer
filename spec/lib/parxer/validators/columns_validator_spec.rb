require "spec_helper"

describe Parxer::ColumnsValidator do
  let(:header) { ["A", "B"] }
  let(:attributes) do
    [
      double(:a, name: "A"),
      double(:b, name: "B")
    ]
  end

  let(:ctx) { double(attributes: attributes, header: header) }

  subject { described_class.new }

  it { expect(subject.id).to eq(:columns) }
  it { expect(subject.config).to eq({}) }

  describe "#validate" do
    let(:execute) { subject.validate(ctx) }

    it { expect(execute).to eq(true) }

    context "with missing columns" do
      let(:header) { ["A"] }

      it { expect(execute).to eq(false) }
    end

    context "with disordered columns" do
      let(:header) { ["B", "A"] }

      it { expect(execute).to eq(false) }
    end
  end
end
