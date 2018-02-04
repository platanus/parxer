require "spec_helper"

describe Parxer::Validator::Email do
  let(:value) { "leandro@platan.us" }
  let(:config) { { context: ctx } }
  let(:ctx) { double(value: value) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:email) }
  it { expect(subject.config).to eq(config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "with blank value" do
      let(:value) { "" }

      it { expect(execute).to eq(true) }
    end

    context "with invalid email" do
      let(:value) { "invalid" }

      it { expect(execute).to eq(false) }
    end

    context "with invalid email" do
      let(:value) { "leandro@" }

      it { expect(execute).to eq(false) }
    end

    context "with invalid email" do
      let(:value) { "leandro@@platan.us" }

      it { expect(execute).to eq(false) }
    end

    context "with invalid email" do
      let(:value) { "@platan.us" }

      it { expect(execute).to eq(false) }
    end
  end
end
