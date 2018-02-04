require "spec_helper"

describe Parxer::Validator::Rut do
  let(:value) { "9.328.797-5" }
  let(:config) { { context: ctx } }
  let(:ctx) { double(value: value) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:rut) }
  it { expect(subject.config).to eq(config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "with blank value" do
      let(:value) { "" }

      it { expect(execute).to eq(true) }
    end

    context "with invalid check digit" do
      let(:value) { "9.328.797-6" }

      it { expect(execute).to eq(false) }
    end

    context "without thousands separator" do
      let(:value) { "9328797-5" }

      it { expect(execute).to eq(true) }
    end

    context "with invalid check digit separator" do
      let(:value) { "9328797_5" }

      it { expect(execute).to eq(true) }
    end

    context "without format" do
      let(:value) { "93287975" }

      it { expect(execute).to eq(true) }
    end

    context "with invalid rut" do
      let(:value) { "invalid" }

      it { expect(execute).to eq(false) }
    end
  end
end
