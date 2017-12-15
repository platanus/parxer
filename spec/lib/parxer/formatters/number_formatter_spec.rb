require "spec_helper"

describe Parxer::NumberFormatter do
  let(:value) { 1.567 }
  let(:ctx) { double(value: value) }
  let(:formatter_config) { {} }
  let(:config) { formatter_config.merge(context: ctx) }

  subject { described_class.new(config) }

  it { expect(subject.config).to eq(formatter_config) }

  describe "#format_value" do
    it { expect(subject.format_value).to eq(1.567) }
    it { expect(subject.format_value).to be_a(Float) }

    context "with nil value" do
      let(:value) { nil }

      it { expect(subject.format_value).to eq(0.0) }
    end

    context "with empty string value" do
      let(:value) { "" }

      it { expect(subject.format_value).to eq(0.0) }
    end

    context "with string format" do
      let(:value) { "1.567" }

      it { expect(subject.format_value).to eq(1.567) }
      it { expect(subject.format_value).to be_a(Float) }
    end

    context "with integer setting" do
      let(:formatter_config) { { integer: true } }

      it { expect(subject.format_value).to eq(1) }
      it { expect(subject.format_value).to be_a(Integer) }

      context "and round setting" do
        before { formatter_config[:round] = 2 }

        it { expect(subject.format_value).to eq(1) }
        it { expect(subject.format_value).to be_a(Integer) }
      end
    end

    context "and round setting" do
      let(:formatter_config) { { round: 1 } }

      it { expect(subject.format_value).to eq(1.6) }
      it { expect(subject.format_value).to be_a(Float) }
    end
  end
end
