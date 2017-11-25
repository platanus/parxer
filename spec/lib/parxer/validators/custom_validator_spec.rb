require "spec_helper"

describe Parxer::CustomValidator do
  let(:value) { 4 }
  let(:ctx) { double(value: value) }
  let(:id) { "custom" }
  let(:condition) { Proc.new { value == 4 } }

  let(:validator_config) do
    {
      id: id,
      condition_proc: condition,
      config_value: 10
    }
  end

  let(:config) { validator_config.merge(context: ctx) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(id.to_sym) }
  it { expect(subject.config).to eq(config) }

  describe "#validate" do
    let(:execute) { subject.validate }

    it { expect(execute).to eq(true) }

    context "when proc resolves to false based on given item and value" do
      let(:value) { 2 }

      it { expect(execute).to eq(false) }
    end

    context "using validator's config" do
      let(:condition) { Proc.new { config[:config_value] + value == 14 } }

      it { expect(execute).to eq(true) }
    end

    context "when condition is not a Proc" do
      let(:condition) { "not a proc" }

      it { expect { execute }.to raise_error(Parxer::ValidatorError, /be a Proc/) }
    end
  end
end
