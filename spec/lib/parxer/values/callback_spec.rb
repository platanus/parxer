require "spec_helper"

describe Parxer::Callback do
  let(:type) { "type" }
  let(:action) { double }
  let(:method_response) { "platanus" }
  let(:ctx) { double(:ctx, some_method: method_response) }
  let(:config) { { context: ctx } }

  let(:params) do
    {
      type: type,
      action: action,
      config: config
    }
  end

  subject { described_class.new(**params) }

  describe "#initialize" do
    it { expect(subject.type).to eq(type.to_sym) }
    it { expect(subject.action).to eq(action) }
    it { expect(subject.context).to eq(ctx) }
    it { expect(subject.config).to eq({}) }
  end

  describe "#run" do
    context "with Proc action" do
      let(:action) do
        Proc.new do
          "hello #{some_method}!"
        end
      end

      it { expect(subject.run).to eq("hello platanus!") }
    end

    context "with method action" do
      let(:action) { :some_method }

      it { expect(subject.run).to eq(method_response) }
    end
  end
end
