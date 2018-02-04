require "spec_helper"

describe Parxer::Formatter::Custom do
  let(:value) { "Hello" }
  let(:ctx) { double(value: value) }

  let(:formatter_proc) do
    Proc.new do
      "#{value} Platanus!"
    end
  end

  let(:formatter_config) { { formatter_proc: formatter_proc } }
  let(:config) { formatter_config.merge(context: ctx) }

  subject { described_class.new(config) }

  it { expect(subject.config).to eq(formatter_config) }

  describe "#apply" do
    it { expect(subject.apply).to eq("Hello Platanus!") }

    context "with blank value" do
      let(:value) { "" }

      it { expect(subject.apply).to be_nil }
    end

    context "with invalid proc" do
      let(:formatter_proc) { "not a proc" }

      it { expect { subject.apply }.to raise_error(Parxer::FormatterError, /'formatter_proc'/) }
    end
  end
end
