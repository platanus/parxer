require "spec_helper"

describe Parxer::Validator::FileFormat do
  let(:file) { nil }
  let(:file_content) { double }
  let(:ctx) { double }

  before do
    allow(ctx).to receive(:csv).and_return(file_content)
    allow(ctx).to receive(:worksheet).and_return(file_content)
    allow(ctx).to receive(:file).and_return(file)
  end

  subject { described_class.new(context: ctx) }

  it { expect(subject.id).to eq(:file_format) }
  it { expect(subject.config).to eq({}) }
  it { expect(subject.context).to eq(ctx) }

  describe "#validate" do
    let(:execute) { subject.validate }

    context "with invalid parser" do
      let(:ctx) { double(file_extension: "doc") }

      it { expect { execute }.to raise_error(Parxer::ValidatorError, "unknown parxer class") }
    end

    context "with xls parser" do
      let(:ctx) { Parxer::XlsParser.new }

      context "with no extension" do
        let(:file) { "file" }

        it { expect { execute }.to raise_error(Parxer::ValidatorError, "file without extension") }
      end

      context "with xls extension" do
        let(:file) { "file.xls" }

        it { expect(execute).to eq(true) }

        context "with invalid content" do
          let(:file_content) { nil }

          it { expect(execute).to eq(false) }
        end
      end

      context "with xlsx extension" do
        let(:file) { "file.xlsx" }

        it { expect(execute).to eq(true) }

        context "with invalid content" do
          let(:file_content) { nil }

          it { expect(execute).to eq(false) }
        end
      end

      context "with invalid extension" do
        let(:file) { "file.csv" }

        it { expect(execute).to eq(false) }

        context "with invalid content" do
          let(:file_content) { nil }

          it { expect(execute).to eq(false) }
        end
      end
    end

    context "with csv parser" do
      let(:ctx) { Parxer::CsvParser.new }

      context "with no extension" do
        let(:file) { "file" }

        it { expect { execute }.to raise_error(Parxer::ValidatorError, "file without extension") }
      end

      context "with xls extension" do
        let(:file) { "file.xls" }

        it { expect(execute).to eq(false) }

        context "with invalid content" do
          let(:file_content) { nil }

          it { expect(execute).to eq(false) }
        end
      end

      context "with xlsx extension" do
        let(:file) { "file.xlsx" }

        it { expect(execute).to eq(false) }

        context "with invalid content" do
          let(:file_content) { nil }

          it { expect(execute).to eq(false) }
        end
      end

      context "with invalid extension" do
        let(:file) { "file.csv" }

        it { expect(execute).to eq(true) }

        context "with invalid content" do
          let(:file_content) { nil }

          it { expect(execute).to eq(false) }
        end
      end
    end
  end
end
