require "spec_helper"

describe Parxer::StringFormatter do
  let(:value) { "1" }
  let(:ctx) { double(value: value) }

  subject { described_class.new(context: ctx) }

  it { expect(subject.config).to eq({}) }

  describe "#apply" do
    it { expect(subject.apply).to eq("1") }

    context "with different format" do
      let(:value) { 1 }

      it { expect(subject.apply).to eq("1") }
    end
  end
end
