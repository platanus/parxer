require "spec_helper"

describe Parxer::Validator::Boolean do
  let(:value) { nil }
  let(:ctx) { double(value: value) }
  let(:config) { { context: ctx } }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:boolean) }
  it { expect(subject.config).to eq(config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "with invalid value" do
      let(:value) { "verdadero" }

      it { expect(execute).to eq(false) }
    end

    context "with invalid value" do
      let(:value) { 2 }

      it { expect(execute).to eq(false) }
    end

    context "with true value" do
      let(:value) { true }

      it { expect(execute).to eq(true) }
    end

    context "with 'true' value" do
      let(:value) { "true" }

      it { expect(execute).to eq(true) }
    end

    context "with 1 value" do
      let(:value) { 1 }

      it { expect(execute).to eq(true) }
    end

    context "with '1' value" do
      let(:value) { "1" }

      it { expect(execute).to eq(true) }
    end

    context "with 't' value" do
      let(:value) { "t" }

      it { expect(execute).to eq(true) }
    end

    context "with false value" do
      let(:value) { false }

      it { expect(execute).to eq(true) }
    end

    context "with 'false' value" do
      let(:value) { "false" }

      it { expect(execute).to eq(true) }
    end

    context "with 0 value" do
      let(:value) { 0 }

      it { expect(execute).to eq(true) }
    end

    context "with '0' value" do
      let(:value) { "0" }

      it { expect(execute).to eq(true) }
    end

    context "with 'f' value" do
      let(:value) { "f" }

      it { expect(execute).to eq(true) }
    end
  end
end
