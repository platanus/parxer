require "spec_helper"

describe Parxer::BaseValidator do
  let(:context) { double }
  subject { described_class.new }

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
