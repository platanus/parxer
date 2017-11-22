require "spec_helper"

RSpec.describe Parxer::XlsDsl do
  before do
    begin
      Object.send(:remove_const, :ParserTest)
    rescue NameError
      # do nothing
    end
  end

  describe "#column" do
    context "without columns" do
      before do
        class ParserTest < Parxer::XlsParser
          # do nothing
        end
      end

      it { expect(ParserTest.attributes).to eq([]) }
    end

    context "adding columns" do
      before do
        class ParserTest < Parxer::XlsParser
          column :brand_name, name: "Platanus"
          column "commune", name: "Vitacura"
        end

        @attrs = ParserTest.attributes
      end

      it { expect(@attrs.count).to eq(2) }
      it { expect(@attrs.first.id).to eq(:brand_name) }
      it { expect(@attrs.first.name).to eq("Platanus") }
      it { expect(@attrs.last.id).to eq(:commune) }
      it { expect(@attrs.last.name).to eq("Vitacura") }

      it "raises error trying to nest columns" do
        expect do
          class ParserTest < Parxer::XlsParser
            column :brand_name, name: "Platanus" do
              column "commune", name: "Vitacura"
            end
          end
        end.to raise_error(Parxer::XlsDslError, "nest column is not allowed")
      end
    end
  end

  context "#validate" do
    context "with valid definition" do
      before do
        class ParserTest < Parxer::XlsParser
          column :brand_name, name: "Platanus" do
            validate(:required)
            validate(:greater_than, value: 2) do
              # some condition
            end
          end

          column :commune, name: "Comuna" do
            validate(:required)
          end
        end

        @attrs = ParserTest.attributes
        @validators_attr1 = @attrs.first.validators
        @validators_attr2 = @attrs.last.validators
      end

      it { expect(@validators_attr1.count).to eq(2) }
      it { expect(@validators_attr1.first).to be_a(Parxer::RequiredValidator) }
      it { expect(@validators_attr1.last).to be_a(Parxer::CustomValidator) }
      it { expect(@validators_attr1.last.config[:value]).to eq(2) }

      it { expect(@validators_attr2.count).to eq(1) }
      it { expect(@validators_attr2.first).to be_a(Parxer::RequiredValidator) }
    end

    it "raises error trying to run validate outside of attribute context" do
      expect do
        class ParserTest < Parxer::XlsParser
          validate(:required)
        end
      end.to raise_error(Parxer::XlsDslError, "validate needs to run in column context")
    end
  end
end
