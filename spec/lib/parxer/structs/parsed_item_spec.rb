require "spec_helper"

describe Parxer::ParsedItem do
  let(:params) { { idx: 1 } }
  let(:item) { described_class.new(params) }

  describe "#initialize" do
    it { expect(item.idx).to eq(1) }
    it { expect(item.errors).to be_a(Hash) }
  end

  describe "#add_error" do
    context "adding error to attribute" do
      before { item.add_error("attr1", "error1") }

      it { expect(item.errors).to eq(attr1: "error1") }

      context "adding a second error to the same attribute" do
        before { item.add_error("attr1", "error2") }

        it { expect(item.errors).to eq(attr1: "error2") }

        context "adding error to another attribute" do
          before { item.add_error("attr2", "error3") }

          it { expect(item.errors).to eq(attr1: "error2", attr2: "error3") }
        end
      end
    end
  end

  describe "#errors?" do
    it { expect(item.errors?).to eq(false) }

    context "with errors" do
      before { expect(item).to receive(:errors).and_return(attribute: "error") }

      it { expect(item.errors?).to eq(true) }
    end
  end
end
