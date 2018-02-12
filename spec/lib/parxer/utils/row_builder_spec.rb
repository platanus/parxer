require "spec_helper"

describe Parxer::RowBuilder do
  describe "#build" do
    let(:attributes) { %i{first_name last_name} }
    subject { described_class.build(attributes).new }

    it { expect { subject.first_name = "l" }.to change(subject, :first_name).from(nil).to("l") }
    it { expect { subject.last_name = "s" }.to change(subject, :last_name).from(nil).to("s") }

    context "with invalid attribute names" do
      let(:attributes) { ["Invalid name"] }

      it { expect { subject }.to raise_error(Parxer::RowError, /invalid 'Invalid name'/) }
    end

    describe "#add_attribute" do
      before { subject.add_attribute(:name, "Lean") }

      it { expect(subject.name).to eq("Lean") }
      it { expect { subject.name = "Vir" }.to change(subject, :name).from("Lean").to("Vir") }
    end
  end
end
