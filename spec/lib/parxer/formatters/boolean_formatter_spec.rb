require "spec_helper"

describe Parxer::Formatter::Boolean do
  let(:value) { true }
  let(:ctx) { double(value: value) }

  subject { described_class.new(context: ctx) }

  it { expect(subject.config).to eq({}) }

  describe "#apply" do
    context "with invalid value" do
      let(:value) { "invalid" }

      it { expect(subject.apply).to be_nil }
    end

    context "with true value" do
      let(:value) { true }

      it { expect(subject.apply).to eq(true) }
    end

    context "with 'true' value" do
      let(:value) { "true" }

      it { expect(subject.apply).to eq(true) }
    end

    context "with 1 value" do
      let(:value) { 1 }

      it { expect(subject.apply).to eq(true) }
    end

    context "with '1' value" do
      let(:value) { "1" }

      it { expect(subject.apply).to eq(true) }
    end

    context "with 't' value" do
      let(:value) { "t" }

      it { expect(subject.apply).to eq(true) }
    end

    context "with false value" do
      let(:value) { false }

      it { expect(subject.apply).to eq(false) }
    end

    context "with 'false' value" do
      let(:value) { "false" }

      it { expect(subject.apply).to eq(false) }
    end

    context "with 0 value" do
      let(:value) { 0 }

      it { expect(subject.apply).to eq(false) }
    end

    context "with '0' value" do
      let(:value) { "0" }

      it { expect(subject.apply).to eq(false) }
    end

    context "with 'f' value" do
      let(:value) { "f" }

      it { expect(subject.apply).to eq(false) }
    end
  end
end
