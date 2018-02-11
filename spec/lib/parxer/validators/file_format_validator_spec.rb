require "spec_helper"

describe Parxer::Validator::FileFormat do
  let(:raw_rows) { nil }
  let(:file_extension) { nil }
  let(:expected_extensions) { [:xls, :xlsx] }
  let(:ctx) { double(raw_rows: raw_rows, file_extension: file_extension) }
  let(:validator_config) { { allowed_extensions: expected_extensions } }
  let(:config) { validator_config.merge(context: ctx) }

  subject { described_class.new(config) }

  it { expect(subject.id).to eq(:file_format) }
  it { expect(subject.config).to eq(validator_config) }
  it { expect(subject.context).to eq(ctx) }

  describe "#validate" do
    let(:execute) { subject.validate }

    context "with valid content" do
      let(:raw_rows) { double }

      it { expect(execute).to eq(false) }

      context "with valid extension" do
        let(:file_extension) { :xls }

        it { expect(execute).to eq(true) }
      end

      context "with valid extension" do
        let(:file_extension) { :xlsx }

        it { expect(execute).to eq(true) }
      end

      context "with invalid extension" do
        let(:file_extension) { :csv }

        it { expect(execute).to eq(false) }
      end
    end

    context "with invalid content" do
      context "with valid extension" do
        let(:file_extension) { :xls }

        it { expect(execute).to eq(false) }
      end

      context "with valid extension" do
        let(:file_extension) { :xlsx }

        it { expect(execute).to eq(false) }
      end

      context "with invalid extension" do
        let(:file_extension) { :csv }

        it { expect(execute).to eq(false) }
      end
    end
  end
end
