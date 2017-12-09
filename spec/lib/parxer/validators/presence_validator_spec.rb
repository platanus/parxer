require "spec_helper"

describe Parxer::PresenceValidator do
  let(:value) { 1 }
  let(:ctx) { double(value: value) }

  subject { described_class.new(context: ctx) }

  it { expect(subject.id).to eq(:presence) }
  it { expect(subject.config).to eq({}) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "with nil value" do
      let(:value) { nil }

      it { expect(execute).to eq(false) }
    end

    context "with empty string" do
      let(:value) { "" }

      it { expect(execute).to eq(false) }
    end

    context "with zero value" do
      let(:value) { 0 }

      it { expect(execute).to eq(true) }
    end

    context "with string value" do
      let(:value) { "string" }

      it { expect(execute).to eq(true) }
    end
  end
end
