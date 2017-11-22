require "spec_helper"

describe Parxer::FileRequiredValidator do
  let(:file) { double }
  let(:ctx) { double(file: file) }

  subject { described_class.new }

  it { expect(subject.id).to eq(:file_required) }

  describe "#validate" do
    let(:execute) { subject.validate(ctx) }

    it { expect(execute).to eq(true) }

    context "with nil file" do
      let(:file) { nil }

      it { expect(execute).to eq(false) }
    end

    context "with empty string" do
      let(:file) { "" }

      it { expect(execute).to eq(false) }
    end
  end
end
