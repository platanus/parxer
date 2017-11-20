require "spec_helper"

describe Parxer::BaseValidator do
  let(:context) { double }
  let(:config) { { config_value: 10 } }
  subject { described_class.new(config: config) }

  it { expect(subject.id).to eq(:base) }
  it { expect(subject.context).to be_nil }
  it { expect(subject.config).to eq(config) }

  describe "#validator" do
    it { expect { subject.condition }.to raise_error(Parxer::ValidatorError, /not implemented/) }
  end

  describe "#validate" do
    it "raises error" do
      expect { subject.validate(context) }.to raise_error(
        Parxer::ValidatorError, /not implemented/
      )
    end
  end
end
