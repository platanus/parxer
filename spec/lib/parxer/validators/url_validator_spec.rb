require "spec_helper"

describe Parxer::UrlValidator do
  let(:value) { "https://platan.us" }
  let(:config) { { context: ctx } }
  let(:ctx) { double(value: value) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:url) }
  it { expect(subject.config).to eq(config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "with blank value" do
      let(:value) { "" }

      it { expect(execute).to eq(true) }
    end

    context "without scheme" do
      let(:value) { "www.platan.us" }

      it { expect(execute).to eq(false) }
    end

    context "with http scheme" do
      let(:value) { "http://platan.us" }

      it { expect(execute).to eq(true) }
    end

    context "with invalid url" do
      let(:value) { "invalid" }

      it { expect(execute).to eq(false) }
    end
  end
end
