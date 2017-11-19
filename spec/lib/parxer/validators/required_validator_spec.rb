require "spec_helper"

describe Parxer::RequiredValidator do
  let(:value) { 1 }
  let(:context) { double(value: value) }
  subject { described_class.new }

  it { expect(subject.id).to eq(:required) }

  describe "#validate" do
    let(:execute) { subject.validate(context) }

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
