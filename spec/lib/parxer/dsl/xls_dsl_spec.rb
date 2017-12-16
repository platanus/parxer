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
          column :brand_name, name: "Brand", format: "string"
          column "commune", name: "Commune"
        end

        @attrs = ParserTest.attributes
      end

      it { expect(@attrs.count).to eq(2) }
      it { expect(@attrs.first.id).to eq(:brand_name) }
      it { expect(@attrs.first.name).to eq("Brand") }
      it { expect(@attrs.first.formatter).to be_a(Parxer::StringFormatter) }
      it { expect(@attrs.last.id).to eq(:commune) }
      it { expect(@attrs.last.name).to eq("Commune") }
      it { expect(@attrs.last.formatter).to be_nil }

      it "raises error trying to nest columns" do
        expect do
          class ParserTest < Parxer::XlsParser
            column :company, name: "Brand" do
              column "commune", name: "Commune"
            end
          end
        end.to raise_error(Parxer::DslError, "'column' can't run inside 'column' block")
      end
    end
  end

  context "#validate" do
    context "with valid definition" do
      before do
        class ParserTest < Parxer::XlsParser
          column :brand_name, name: "Brand" do
            validate(:presence)
            validate(:greater_than, value: 2) do
              # some condition
            end
          end

          column :commune, name: "Comuna" do
            validate(:presence)
          end
        end

        @attrs = ParserTest.attributes
        @validators_attr1 = @attrs.first.validators
        @validators_attr2 = @attrs.last.validators
      end

      it { expect(@validators_attr1.count).to eq(2) }
      it { expect(@validators_attr1.first).to be_a(Parxer::PresenceValidator) }
      it { expect(@validators_attr1.last).to be_a(Parxer::CustomValidator) }
      it { expect(@validators_attr1.last.config[:value]).to eq(2) }

      it { expect(@validators_attr2.count).to eq(1) }
      it { expect(@validators_attr2.first).to be_a(Parxer::PresenceValidator) }
    end

    it "raises error trying to run validate outside of attribute context" do
      expect do
        class ParserTest < Parxer::XlsParser
          validate(:presence)
        end
      end.to raise_error(Parxer::DslError, "'validate' needs to run inside 'column' block")
    end
  end

  context "#format_with" do
    context "with valid definition" do
      before do
        class ParserTest < Parxer::XlsParser
          column :amount, name: "Amount" do
            format_with(:number, round: 2)
          end

          column :brand_name, name: "Brand" do
            format_with do
              # some formatting function
            end
          end

          column :commune, name: "Commune" do
            format_with(opt: 1) do
              # some formatting function
            end
          end
        end

        @attrs = ParserTest.attributes
        @formatter_attr1 = @attrs.first.formatter
        @formatter_attr2 = @attrs.second.formatter
        @formatter_attr3 = @attrs.last.formatter
      end

      it { expect(@formatter_attr1).to be_a(Parxer::NumberFormatter) }
      it { expect(@formatter_attr1.config).to eq(round: 2) }

      it { expect(@formatter_attr2).to be_a(Parxer::CustomFormatter) }
      it { expect(@formatter_attr2.config.keys).to contain_exactly(:formatter_proc) }

      it { expect(@formatter_attr3).to be_a(Parxer::CustomFormatter) }
      it { expect(@formatter_attr3.config.keys).to contain_exactly(:opt, :formatter_proc) }
    end

    it "raises error trying to run format_with outside of attribute context" do
      expect do
        class ParserTest < Parxer::XlsParser
          format_with(:number)
        end
      end.to raise_error(Parxer::DslError, "'format_with' needs to run inside 'column' block")
    end
  end

  context "#validate_xls" do
    context "with valid definition" do
      before do
        class ParserTest < Parxer::XlsParser
          validate_xls(:items_count, max: 200)
          validate_xls(:custom, value: 2) do
            # some condition
          end
        end

        validators = ParserTest.file_validators.last(2)
        @validator1 = validators.first
        @validator2 = validators.last
      end

      it { expect(@validator1).to be_a(Parxer::ItemsCountValidator) }
      it { expect(@validator1.config[:id]).to eq(:items_count) }
      it { expect(@validator1.config[:max]).to eq(200) }

      it { expect(@validator2).to be_a(Parxer::CustomValidator) }
      it { expect(@validator2.config[:id]).to eq(:custom) }
      it { expect(@validator2.config[:value]).to eq(2) }
    end
  end
end
