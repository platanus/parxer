require "spec_helper"

describe Parxer::ItemsCountValidator do
  let(:max_count) { 10 }
  let(:items_count) { 5 }
  let(:validator_config) { { max: max_count } }
  let(:config) { validator_config.merge(context: ctx) }
  let(:ctx) { double(items_count: items_count) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:items_count) }
  it { expect(subject.config).to eq(validator_config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "when rows count is equals to max count" do
      let(:items_count) { max_count }

      it { expect(execute).to eq(true) }
    end

    context "when rows count is greater than max count" do
      let(:items_count) { 11 }

      it { expect(execute).to eq(false) }
    end
  end
end
