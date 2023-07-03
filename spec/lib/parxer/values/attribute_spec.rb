require "spec_helper"

describe Parxer::Attribute do
  let(:id) { "id" }
  let(:params) { { name: double } }
  subject { described_class.new(id, **params) }

  describe "#initialize" do
    it { expect(subject.id).to eq(id.to_sym) }
    it { expect(subject.name).to eq(params[:name]) }
    it { expect(subject.validators).to eq([]) }
  end

  describe "#add_formatter" do
    def add_formatter
      subject.add_formatter(formatter_name, formatter_config, &formatter_proc)
    end

    let(:formatter_name) { :string }
    let(:formatter_config) { double }
    let(:formatter_proc) { Proc.new {} }
    let(:formatter) { double }

    before do
      expect(Parxer::FormatterBuilder).to receive(:build).with(
        formatter_name, formatter_config, &formatter_proc
      ).and_return(formatter)
    end

    it { expect { add_formatter }.to change(subject, :formatter).from(nil).to(formatter) }
  end
end
