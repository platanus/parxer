require "spec_helper"

describe Parxer::Validator::Datetime do
  let(:value) { Date.current }
  let(:date_format) { nil }
  let(:validator_config) { { format: date_format } }
  let(:config) { validator_config.merge(context: ctx) }
  let(:ctx) { double(value: value) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:datetime) }
  it { expect(subject.config).to eq(validator_config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "with blank value" do
      let(:value) { "" }

      it { expect(execute).to eq(true) }
    end

    context "with invalid value" do
      let(:value) { "not a date" }

      it { expect(execute).to eq(false) }
    end

    context "with custom format" do
      let(:date_format) { "%Y%M" }

      it { expect(execute).to eq(false) }

      context "and value matching format" do
        let(:value) { "200712" }

        it { expect(execute).to eq(true) }
      end
    end

    context "with Datetime value" do
      let(:value) { DateTime.current }

      it { expect(execute).to eq(true) }
    end

    context "working with ranges" do
      let(:gt_limit) { nil }
      let(:gteq_limit) { nil }
      let(:lt_limit) { nil }
      let(:lteq_limit) { nil }
      let(:validator_config) do
        {
          gt: gt_limit,
          gteq: gteq_limit,
          lt: lt_limit,
          lteq: lteq_limit
        }
      end

      context "with gt limit exceeded" do
        let(:gt_limit) { value }

        it { expect(execute).to eq(false) }
      end

      context "with gt limit not exceeded" do
        let(:gt_limit) { value - 1.day }

        it { expect(execute).to eq(true) }
      end

      context "with gteq limit exceeded" do
        let(:gteq_limit) { value + 1.day }

        it { expect(execute).to eq(false) }
      end

      context "with gteq limit not exceeded" do
        let(:gteq_limit) { value }

        it { expect(execute).to eq(true) }
      end

      context "with lt limit exceeded" do
        let(:lt_limit) { value }

        it { expect(execute).to eq(false) }
      end

      context "with lt limit not exceeded" do
        let(:lt_limit) { value + 1.day }

        it { expect(execute).to eq(true) }
      end

      context "with lteq limit exceeded" do
        let(:lteq_limit) { value - 1.day }

        it { expect(execute).to eq(false) }
      end

      context "with lteq limit not exceeded" do
        let(:lteq_limit) { value }

        it { expect(execute).to eq(true) }
      end

      context "when limit has not value type" do
        let(:gt_limit) { "not a date type" }

        it { expect { execute }.to raise_error(Parxer::ValidatorError, /'gt' has not/) }
      end
    end
  end
end
