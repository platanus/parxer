require "spec_helper"

describe Parxer::ItemBuilder do
  describe "#build" do
    let(:attributes) { %i{first_name last_name} }
    subject { described_class.build(attributes).new }

    it { expect { subject.first_name = "l" }.to change(subject, :first_name).from(nil).to("l") }
    it { expect { subject.last_name = "s" }.to change(subject, :last_name).from(nil).to("s") }

    context "with already defined attributes" do
      let(:attributes) { %i{to_s} }

      it { expect { subject }.to raise_error(Parxer::ItemError, /'to_s' already defined/) }
    end

    context "with invalid attribute names" do
      let(:attributes) { ["Invalid name"] }

      it { expect { subject }.to raise_error(Parxer::ItemError, /invalid 'Invalid name'/) }
    end
  end
end
