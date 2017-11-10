require "spec_helper"

# rubocop:disable Metrics/LineLength
describe Parxer::AttributeErrors do
  describe "#initialize" do
    before { @attrs_errors = described_class.new("attr") }

    it { expect(@attrs_errors.attribute_name).to eq(:attr) }
    it { expect(@attrs_errors.errors).to eq([]) }
  end

  describe "#==" do
    before { @attrs_errors = described_class.new("attr") }

    it { expect(@attrs_errors == "attr").to eq(true) }
    it { expect(@attrs_errors == :attr).to eq(true) }
    it { expect(@attrs_errors == nil).to eq(false) }
    it { expect(@attrs_errors == "").to eq(false) }
  end

  describe "#add_error" do
    let(:attr_name) { "attr" }
    let(:error) { "error" }

    subject { described_class.new(attr_name) }

    context "adding error" do
      it { expect { subject.add_error(error) }.to change(subject.errors, :count).from(0).to(1) }
      it { expect { subject.add_error(error) }.to change(subject.errors, :first).from(nil).to(:error) }

      context "adding the same error twice" do
        before { subject.add_error(error) }

        it { expect { subject.add_error(error) }.not_to change(subject.errors, :count) }
      end

      context "adding another error" do
        before { subject.add_error("another_error") }

        it { expect { subject.add_error(error) }.to change(subject.errors, :count).from(1).to(2) }
      end
    end
  end
end
