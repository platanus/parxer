require "spec_helper"

describe Parxer::Formatter::Rut do
  let(:value) { "23.414.654-8" }
  let(:ctx) { double(value: value) }
  let(:formatter_config) { {} }
  let(:config) { formatter_config.merge(context: ctx) }

  subject { described_class.new(config) }

  it { expect(subject.config).to eq(formatter_config) }

  describe "#apply" do
    context "with formatted rut" do
      it { expect(subject.apply).to eq(value) }
    end

    context "with clean rut" do
      let(:value) { "234146548" }

      it { expect(subject.apply).to eq("23.414.654-8") }
    end

    context "with dirty rut" do
      let(:value) { "a@#/(^234...1465o48<>zz" }

      it { expect(subject.apply).to eq("23.414.654-8") }
    end

    context "with empty rut" do
      let(:value) { "" }

      it { expect(subject.apply).to be_nil }
    end

    context "with k last digit" do
      let(:value) { "12864914-k" }

      it { expect(subject.apply).to eq("12.864.914-K") }
    end

    context "with K last digit" do
      let(:value) { "12864914K" }

      it { expect(subject.apply).to eq("12.864.914-K") }
    end

    context "with nil value" do
      let(:value) { nil }

      it { expect(subject.apply).to be_nil }
    end

    context "with clean option" do
      let(:formatter_config) { { clean: true } }

      it { expect(subject.apply).to eq("234146548") }
    end
  end
end
