require "spec_helper"

# rubocop:disable Metrics/LineLength
describe Parxer::Attributes do
  let(:attr_id) { "attr" }
  let(:params) { { name: "attr name" } }

  describe "#add_attribute" do
    subject { described_class.new }

    it { expect { subject.add_attribute(attr_id, params) }.to change(subject, :count).from(0).to(1) }
    it { expect { subject.add_attribute(attr_id, params) }.to change(subject, :first).from(nil).to(kind_of(Parxer::Attribute)) }

    context "with added item" do
      before { @item = subject.add_attribute(attr_id, params) }

      it { expect(@item.id).to eq(attr_id.to_sym) }
      it { expect(@item.name).to eq(params[:name]) }
      it { expect(@item.validators).to eq([]) }
    end
  end

  describe "#add_add_validator" do
    let(:validator) { double }

    subject { described_class.new }

    it { expect { subject.add_validator(attr_id, validator) }.to raise_error(Parxer::AttributesError, "trying to add validator on non existent attribute") }

    context "with found item item" do
      before { @item = subject.add_attribute(attr_id, params) }

      it { expect { subject.add_validator(attr_id, validator) }.to change(@item.validators, :count).from(0).to(1) }
    end
  end
end
