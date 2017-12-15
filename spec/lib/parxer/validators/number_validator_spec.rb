require "spec_helper"

describe Parxer::NumberValidator do
  let(:value) { 1 }
  let(:validator_config) { {} }
  let(:config) { validator_config.merge(context: ctx) }
  let(:ctx) { double(value: value) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:number) }
  it { expect(subject.config).to eq(validator_config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "with blank value" do
      let(:value) { "" }

      it { expect(execute).to eq(true) }
    end

    context "with invalid number" do
      let(:value) { "invalid" }

      it { expect(execute).to eq(false) }
    end

    context "with decimal value" do
      let(:value) { 1.5 }

      it { expect(execute).to eq(true) }
    end

    context "with decimal string value" do
      let(:value) { "1.5" }

      it { expect(execute).to eq(true) }
    end

    context "with integer string value" do
      let(:value) { "1" }

      it { expect(execute).to eq(true) }
    end

    context "with only_integer option to true" do
      let(:validator_config) { { only_integer: true } }

      it { expect(execute).to eq(true) }

      context "and decimal value" do
        let(:value) { 1.5 }

        it { expect(execute).to eq(false) }
      end
    end

    context "with only_integer option to false" do
      let(:validator_config) { { only_integer: false } }

      it { expect(execute).to eq(true) }

      context "and decimal value" do
        let(:value) { 1.5 }

        it { expect(execute).to eq(true) }
      end
    end

    context "with allow_negative option to false" do
      let(:validator_config) { { allow_negative: false } }

      it { expect(execute).to eq(true) }

      context "and negative value" do
        let(:value) { -1 }

        it { expect(execute).to eq(false) }
      end
    end

    context "with allow_negative option to true" do
      let(:validator_config) { { allow_negative: true } }

      it { expect(execute).to eq(true) }

      context "and negative value" do
        let(:value) { -1 }

        it { expect(execute).to eq(true) }
      end
    end

    context "working with ranges" do
      let(:gt_limit) { nil }
      let(:gteq_limit) { nil }
      let(:lt_limit) { nil }
      let(:lteq_limit) { nil }
      let(:extra_config) { {} }
      let(:range_config) do
        {
          gt: gt_limit,
          gteq: gteq_limit,
          lt: lt_limit,
          lteq: lteq_limit
        }
      end

      let(:validator_config) { range_config.merge(extra_config) }

      context "with gt limit exceeded" do
        let(:gt_limit) { 1 }

        it { expect(execute).to eq(false) }
      end

      context "with gt limit not exceeded" do
        let(:gt_limit) { 0 }

        it { expect(execute).to eq(true) }
      end

      context "with gteq limit exceeded" do
        let(:gteq_limit) { 2 }

        it { expect(execute).to eq(false) }
      end

      context "with gteq limit not exceeded" do
        let(:gteq_limit) { 1 }

        it { expect(execute).to eq(true) }
      end

      context "with lt limit exceeded" do
        let(:lt_limit) { 1 }

        it { expect(execute).to eq(false) }
      end

      context "with lt limit not exceeded" do
        let(:lt_limit) { 2 }

        it { expect(execute).to eq(true) }
      end

      context "with lteq limit exceeded" do
        let(:lteq_limit) { 0 }

        it { expect(execute).to eq(false) }
      end

      context "with lteq limit not exceeded" do
        let(:lteq_limit) { 1 }

        it { expect(execute).to eq(true) }
      end

      context "when limit has not value type" do
        let(:gt_limit) { 1.5 }
        let(:extra_config) { { only_integer: true } }

        it { expect { execute }.to raise_error(Parxer::ValidatorError, /'gt' has not/) }
      end

      context "with decimal limit" do
        let(:gt_limit) { 1.5 }

        it { expect(execute).to eq(false) }
      end

      context "with string limit" do
        let(:gt_limit) { "1.5" }

        it { expect(execute).to eq(false) }
      end
    end
  end
end
