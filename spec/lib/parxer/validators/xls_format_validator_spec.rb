require "spec_helper"

describe Parxer::XlsFormatValidator do
  let(:file) { double }
  let(:ctx) { double(file: file) }

  subject { described_class.new(context: ctx) }

  it { expect(subject.id).to eq(:xls_format) }
  it { expect(subject.config).to eq({}) }

  describe "#validate" do
    let(:execute) { subject.validate }

    context "with invalid xls file" do
      before do
        allow(Spreadsheet).to receive(:open).with(file).and_raise(Ole::Storage::FormatError)
      end

      it { expect(execute).to eq(false) }
    end

    context "with valid xls file" do
      before { allow(Spreadsheet).to receive(:open).with(file).and_return("content") }

      it { expect(execute).to eq(true) }
    end
  end
end
