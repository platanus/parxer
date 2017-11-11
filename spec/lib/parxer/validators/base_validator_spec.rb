require "spec_helper"

# rubocop:disable Metrics/LineLength
describe Parxer::BaseValidator do
  let(:context) { double }
  subject { described_class.new(context) }

  describe "#initialize" do
    it { expect(subject.context).to eq(context) }
  end

  describe "#validator" do
    it { expect { subject.validator }.to raise_error(Parxer::ValidatorError, /not implemented/) }
  end

  describe "#validate" do
    it { expect { subject.validate(:foo, :bar) }.to raise_error(Parxer::ValidatorError, /not implemented/) }
  end
end
