require "spec_helper"

describe Parxer::BaseValidator do
  let(:ctx) { double }

  subject { described_class.new }

  it { expect(subject.id).to eq(:base) }
  it { expect(subject.config).to eq({}) }

  describe "#validator" do
    it { expect { subject.condition }.to raise_error(Parxer::ValidatorError, /not implemented/) }
  end

  describe "#validate" do
    it { expect { subject.validate({}) }.to raise_error(Parxer::ValidatorError, /not implemented/) }
  end
end
