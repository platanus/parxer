require "spec_helper"

describe Parxer::InclusionValidator do
  let(:options) { [1, 2, 3] }
  let(:value) { 1 }
  let(:validator_config) { { in: options } }
  let(:config) { validator_config.merge(context: ctx) }
  let(:ctx) { double(value: value) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:inclusion) }
  it { expect(subject.config).to eq(validator_config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "when string value" do
      let(:value) { "3" }

      it { expect(execute).to eq(true) }
    end

    context "when value is not included in options" do
      let(:value) { 4 }

      it { expect(execute).to eq(false) }
    end

    context "when options are blank" do
      let(:options) { "" }

      it { expect { execute }.to raise_error(Parxer::ValidatorError, /is required/) }
    end

    context "when options is not an Array" do
      let(:options) { double }

      it { expect { execute }.to raise_error(Parxer::ValidatorError, /needs to be Array/) }
    end
  end
end
