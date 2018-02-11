require "spec_helper"

describe Parxer::RowErrors do
  let(:errors) { described_class.new }

  describe "#add_error" do
    context "adding error to attribute" do
      before { errors.add_error("attr1", "error1") }

      it { expect(errors).to eq(attr1: "error1") }

      context "adding a second error to the same attribute" do
        before { errors.add_error("attr1", "error2") }

        it { expect(errors).to eq(attr1: "error2") }

        context "adding error to another attribute" do
          before { errors.add_error("attr2", "error3") }

          it { expect(errors).to eq(attr1: "error2", attr2: "error3") }
        end
      end
    end
  end

  describe "#errors?" do
    it { expect(errors.errors?).to eq(false) }

    context "with errors" do
      before { errors.add_error("attr1", "error") }

      it { expect(errors.errors?).to eq(true) }
    end
  end

  describe "#attribute_error?" do
    before { errors.add_error("attr1", "error") }

    it { expect(errors.attribute_error?(:attr1)).to eq(true) }
    it { expect(errors.attribute_error?("attr1")).to eq(true) }
    it { expect(errors.attribute_error?(:attr2)).to eq(false) }
  end

  describe "#attribute_error" do
    before { errors.add_error("attr1", "error") }

    it { expect(errors.attribute_error(:attr1)).to eq("error") }
    it { expect(errors.attribute_error("attr1")).to eq("error") }
    it { expect(errors.attribute_error(:attr2)).to be_nil }
  end
end
