require "spec_helper"

# rubocop:disable Metrics/LineLength
describe Parxer::ItemErrors do
  describe "#add_error" do
    let(:attr_name) { "attr" }
    let(:error) { "error" }

    subject { described_class.new }

    it { expect { subject.add_error(attr_name, error) }.to change(subject, :count).from(0).to(1) }
    it { expect { subject.add_error(attr_name, error) }.to change(subject, :first).from(nil).to(kind_of(Parxer::AttributeErrors)) }

    context "adding the same error twice" do
      before { subject.add_error(attr_name, error) }

      it { expect { subject.add_error(attr_name, error) }.not_to change(subject, :count) }
    end

    context "adding another error" do
      before { subject.add_error(attr_name, "another_error") }

      it { expect { subject.add_error(attr_name, error) }.not_to change(subject, :count) }
    end

    context "adding error to another attribute" do
      before { subject.add_error("another_attr", error) }

      it { expect { subject.add_error(attr_name, error) }.to change(subject, :count).from(1).to(2) }
    end
  end
end
