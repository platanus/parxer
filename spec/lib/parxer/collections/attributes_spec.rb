require "spec_helper"

# rubocop:disable Metrics/LineLength
describe Parxer::Attributes do
  let(:attr_id) { "attr" }
  let(:params) { { name: "attr name" } }
  subject { described_class.new }

  describe "#add_attribute" do
    it { expect { subject.add_attribute(attr_id, params) }.to change(subject, :count).from(0).to(1) }
    it { expect { subject.add_attribute(attr_id, params) }.to change(subject, :first).from(nil).to(kind_of(Parxer::Attribute)) }

    context "with added item" do
      before { @item = subject.add_attribute(attr_id, params) }

      it { expect(@item.id).to eq(attr_id.to_sym) }
      it { expect(@item.name).to eq(params[:name]) }
      it { expect(@item.validators).to eq([]) }
      it { expect { subject.add_attribute(attr_id, params) }.to raise_error(Parxer::AttributesError, "trying to add attribute with existent id") }
    end
  end

  describe "#find_attribute" do
    before { subject.add_attribute(attr_id, params) }

    it { expect(subject.find_attribute(attr_id)).to be_a(Parxer::Attribute) }
    it { expect(subject.find_attribute("another")).to be_nil }
  end
end
