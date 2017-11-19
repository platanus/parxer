require "spec_helper"

describe Parxer::ValidationExecutor do
  describe "#execute" do
    let(:validator_result) { false }
    let(:validator_id) { double }
    let(:validator) { double(validate: validator_result, id: validator_id) }
    let(:validators) { [validator] }
    let(:attribute_id) { double }
    let(:attribute) { double(id: attribute_id, validators: validators) }
    let(:item) { double }
    let(:parser) { double }

    let(:execute) { described_class.execute(attribute, item, parser) }

    it "adds error to item" do
      expect(validator).to receive(:validate).with(parser).once
      expect(item).to receive(:add_error).with(attribute_id, validator_id).once
      execute
    end

    context "when validator returns true value" do
      let(:validator_result) { true }

      it "does not add error to item" do
        expect(validator).to receive(:validate).with(parser).once
        expect(item).not_to receive(:add_error)
        execute
      end
    end
  end
end
