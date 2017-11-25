require "spec_helper"

describe Parxer::ParsedItem do
  let(:params) { { idx: 1 } }
  let(:item) { described_class.new(params) }

  describe "#initialize" do
    it { expect(item.idx).to eq(1) }
    it { expect(item.errors).to be_a(Parxer::ItemErrors) }
  end

  describe "#add_error" do
    let(:errors) { double(add_error: true) }
    let(:attribute_name) { double }
    let(:error) { double }

    before do
      expect(item).to receive(:errors).and_return(errors)
      expect(errors).to receive(:add_error).with(attribute_name, error).and_return(true)
    end

    it { expect(item.add_error(attribute_name, error)).to eq(true) }
  end

  describe "#errors?" do
    it { expect(item.errors?).to eq(false) }

    context "with errors" do
      before { expect(item).to receive(:errors).and_return([double]) }

      it { expect(item.errors?).to eq(true) }
    end
  end
end
