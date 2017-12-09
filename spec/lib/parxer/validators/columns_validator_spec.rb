require "spec_helper"

describe Parxer::HeaderOrderValidator do
  let(:header) { ["A", "B"] }
  let(:attributes) do
    [
      double(:a, name: "A"),
      double(:b, name: "B")
    ]
  end

  let(:ctx) { double(attributes: attributes, header: header) }

  subject { described_class.new(context: ctx) }

  it { expect(subject.id).to eq(:header_order) }
  it { expect(subject.config).to eq({}) }

  describe "#validate" do
    let(:execute) { subject.validate }

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
