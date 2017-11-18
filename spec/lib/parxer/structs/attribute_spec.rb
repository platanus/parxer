require "spec_helper"

describe Parxer::Attribute do
  let(:id) { "id" }
  let(:params) { { name: double } }
  subject { described_class.new(id, params) }

  describe "#initialize" do
    it { expect(subject.id).to eq(id.to_sym) }
    it { expect(subject.name).to eq(params[:name]) }
  end
end
