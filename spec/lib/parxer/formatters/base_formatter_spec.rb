require "spec_helper"

describe Parxer::BaseFormatter do
  let(:ctx) { double }

  subject { described_class.new(context: ctx) }

  it { expect(subject.config).to eq({}) }

  describe "#format_value" do
    it { expect { subject.format_value }.to raise_error(Parxer::FormatterError, /not implemented/) }
  end

  describe "#context" do
    it { expect(subject.context).to eq(ctx) }

    context "with no context" do
      let(:ctx) { nil }

      it { expect { subject.context }.to raise_error(Parxer::ContextError, /not implemented/) }
    end
  end
end
