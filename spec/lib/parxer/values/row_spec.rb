require "spec_helper"

describe Parxer::Row do
  let(:params) { { idx: 1 } }
  let(:row) { described_class.new(params) }

  describe "#initialize" do
    it { expect(row.idx).to eq(1) }
    it { expect(row.errors).to be_a(Parxer::RowErrors) }
  end
end
