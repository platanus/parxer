require "spec_helper"

describe Parxer::Validator::Base do
  let(:ctx) { double }

  subject { described_class.new(context: ctx) }

  it { expect(subject.id).to eq(:basis) }
  it { expect(subject.config).to eq({}) }

  describe "#validate" do
    it { expect { subject.validate }.to raise_error(Parxer::ValidatorError, /not implemented/) }
  end

  describe "#context" do
    it { expect(subject.context).to eq(ctx) }

    context "with no context" do
      let(:ctx) { nil }

      it { expect { subject.context }.to raise_error(Parxer::ContextError, /not implemented/) }
    end
  end
end
