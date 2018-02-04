require "spec_helper"

describe Parxer::FormatterBuilder do
  describe "#build" do
    let(:formatter_name) { :boolean }
    let(:ctx) { double }
    let(:config) { { context: ctx } }
    let(:formatter_proc) { Proc.new {} }

    def build
      described_class.build(formatter_name, config, &formatter_proc)
    end

    context "with existent formatter" do
      before { @formatter = build }

      it { expect(@formatter).to be_a(Parxer::Formatter::Boolean) }
      it { expect(@formatter.config[:formatter_proc]).to be_nil }
      it { expect(@formatter.context).to eq(ctx) }
    end

    context "with unknown formatter" do
      let(:formatter_name) { "unknown" }

      before { @formatter = build }

      it { expect(@formatter).to be_a(Parxer::Formatter::Custom) }
      it { expect(@formatter.config[:formatter_proc]).to eq(formatter_proc) }
      it { expect(@formatter.context).to eq(ctx) }
    end
  end
end
