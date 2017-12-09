require "spec_helper"

describe Parxer::ParsedItem do
  let(:params) { { idx: 1 } }
  let(:item) { described_class.new(params) }

  describe "#initialize" do
    it { expect(item.idx).to eq(1) }
    it { expect(item.errors).to be_a(Parxer::ItemErrors) }
  end
end
