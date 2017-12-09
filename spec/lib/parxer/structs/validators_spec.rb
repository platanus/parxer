require "spec_helper"

describe Parxer::Validators do
  let(:validator_name) { :required }
  let(:ctx) { double }
  let(:config) { { some: "config", context: ctx } }
  let(:block) { Proc.new {} }

  subject { described_class.new }

  describe "#add_validator" do
    def add_validator
      subject.add_validator(validator_name, config, &block)
    end

    context "adding known validator" do
      before { @validator = add_validator }

      it { expect(@validator).to be_a(Parxer::RequiredValidator) }
      it { expect(@validator.id).to eq(:required) }
      it { expect(@validator.context).to eq(ctx) }
      it { expect(@validator.config[:some]).to eq("config") }

      context "trying to add the same validator again" do
        it { expect { add_validator }.to raise_error(Parxer::ValidatorsError, /existent id/) }
      end
    end

    context "adding custom validator" do
      let(:validator_name) { "another" }
      before { @validator = add_validator }

      it { expect(@validator).to be_a(Parxer::CustomValidator) }
      it { expect(@validator.id).to eq(:another) }
      it { expect(@validator.context).to eq(ctx) }
      it { expect(@validator.config[:some]).to eq("config") }
    end
  end
end
