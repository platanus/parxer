require "spec_helper"

describe Parxer::Formatter::Base do
  let(:value) { 1 }
  let(:ctx) { double(value: value) }
  let(:formatter_config) { {} }
  let(:config) { formatter_config.merge(context: ctx) }

  subject { described_class.new(config) }

  it { expect(subject.config).to eq(formatter_config) }

  describe "#apply" do
    it { expect { subject.apply }.to raise_error(Parxer::FormatterError, /not implemented/) }

    context "with no value" do
      let(:value) { nil }

      it { expect(subject.apply).to be_nil }

      context "and custom default value" do
        let(:formatter_config) { { default: "default" } }

        it { expect(subject.apply).to eq("default") }
      end
    end

    context "with empty string value" do
      let(:value) { "" }

      it { expect(subject.apply).to be_nil }
    end
  end

  describe "#context" do
    it { expect(subject.context).to eq(ctx) }

    context "with no context" do
      let(:ctx) { nil }

      it { expect { subject.context }.to raise_error(Parxer::ContextError, /not implemented/) }
    end
  end
end
