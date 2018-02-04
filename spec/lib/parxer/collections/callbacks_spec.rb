require "spec_helper"

# rubocop:disable Metrics/LineLength
describe Parxer::Callbacks do
  let(:type) { "after_parse_item" }
  let(:action) { Proc.new {} }
  let(:config) { nil }

  let(:params) do
    {
      type: type,
      action: action,
      config: config
    }
  end

  subject { described_class.new }

  describe "#add_callback" do
    context "with valid params" do
      it { expect { subject.add_callback(params) }.to change(subject, :count).from(0).to(1) }
      it { expect { subject.add_callback(params) }.to change(subject, :first).from(nil).to(kind_of(Parxer::Callback)) }
    end

    context "with invalid type" do
      let(:type) { "invalid" }

      it { expect { subject.add_callback(params) }.to raise_error(Parxer::CallbacksError, "invalid 'invalid' callback type") }
    end

    context "with invalid action" do
      let(:action) { "invalid" }

      it { expect { subject.add_callback(params) }.to raise_error(Parxer::CallbacksError, "action param must by a Proc or symbol method name") }
    end
  end

  describe "#by_type" do
    before { subject.add_callback(params) }

    it { expect(subject.by_type(:after_parse_item).count).to eq(1) }
    it { expect(subject.by_type(:invalid).count).to eq(0) }
  end
end
