require "spec_helper"

describe Parxer::CustomValidator do
  let(:context) { double }
  let(:validator) do
    Proc.new do |item, value|
      (item + value) == 4
    end
  end

  let(:item) { 1 }
  let(:value) { 3 }
  subject { described_class.new(context, validator) }

  describe "#validate" do
    let(:execute) { subject.validate(item, value) }

    it { expect(execute).to eq(true) }

    context "when proc resolves to false based on given item and value" do
      let(:item) { 2 }

      it { expect(execute).to eq(false) }
    end

    context "when validator is not a Proc" do
      let(:validator) { "not a proc" }

      it { expect { subject.validator }.to raise_error(Parxer::ValidatorError, /be a Proc/) }
    end

    context "using given context" do
      let(:context) do
        [1, 2]
      end

      let(:validator) do
        Proc.new do |_item, value|
          (count + value) == 5
        end
      end

      it { expect(execute).to eq(true) }
    end
  end
end
