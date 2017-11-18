require "spec_helper"

describe Parxer::CustomValidator do
  let(:context) { double(value: value, item: item, another_method: 2) }
  let(:condition) { Proc.new { (item + value) == 4 } }

  let(:item) { 1 }
  let(:value) { 3 }
  subject { described_class.new(condition) }

  describe "#validate" do
    let(:execute) { subject.validate(context) }

    it { expect(execute).to eq(true) }

    context "when proc resolves to false based on given item and value" do
      let(:item) { 2 }

      it { expect(execute).to eq(false) }
    end

    context "when condition is not a Proc" do
      let(:condition) { "not a proc" }

      it { expect { execute }.to raise_error(Parxer::ValidatorError, /be a Proc/) }
    end

    context "calling not delegated method from given context" do
      let(:condition) do
        Proc.new { (another_method + value) == 5 }
      end

      it { expect(execute).to eq(true) }
    end
  end
end
