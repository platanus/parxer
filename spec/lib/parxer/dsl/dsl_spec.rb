require "spec_helper"

# rubocop:disable Metrics/LineLength
RSpec.describe Parxer::Dsl do
  describe "#define_attribute" do
    context "adding columns" do
      before do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_attribute :brand_name, name: "Brand", format: "string"
          define_attribute "commune", name: "Commune"
        end

        @attrs = ParserTest.attributes
      end

      it { expect(@attrs.count).to eq(2) }
      it { expect(@attrs.first.id).to eq(:brand_name) }
      it { expect(@attrs.first.name).to eq("Brand") }
      it { expect(@attrs.first.formatter).to be_a(Parxer::Formatter::String) }
      it { expect(@attrs.last.id).to eq(:commune) }
      it { expect(@attrs.last.name).to eq("Commune") }
      it { expect(@attrs.last.formatter).to be_nil }

      it "raises error trying to nest columns" do
        expect do
          class ParserTest < Parxer::BaseParser
            include Parxer::Dsl

            define_attribute :company, name: "Brand" do
              define_attribute "commune", name: "Commune"
            end
          end
        end.to raise_error(Parxer::DslError, "'define_attribute' can't run inside 'define_attribute' block")
      end
    end
  end

  context "#define_attribute_validator" do
    context "with valid definition" do
      before do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_attribute :brand_name, name: "Brand" do
            define_attribute_validator(:presence)
            define_attribute_validator(:greater_than, value: 2) do
              # some condition
            end
          end

          define_attribute :commune, name: "Comuna" do
            define_attribute_validator(:presence)
          end
        end

        @attrs = ParserTest.attributes
        @validators_attr1 = @attrs.first.validators
        @validators_attr2 = @attrs.last.validators
      end

      it { expect(@validators_attr1.count).to eq(2) }
      it { expect(@validators_attr1.first).to be_a(Parxer::Validator::Presence) }
      it { expect(@validators_attr1.last).to be_a(Parxer::Validator::Custom) }
      it { expect(@validators_attr1.last.config[:value]).to eq(2) }

      it { expect(@validators_attr2.count).to eq(1) }
      it { expect(@validators_attr2.first).to be_a(Parxer::Validator::Presence) }
    end

    it "raises error trying to run validate outside of attribute context" do
      expect do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_attribute_validator(:presence)
        end
      end.to raise_error(Parxer::DslError, "'define_attribute_validator' needs to run inside 'define_attribute' block")
    end
  end

  context "#define_formatter" do
    context "with valid definition" do
      before do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_attribute :amount, name: "Amount" do
            define_formatter(:number, round: 2)
          end

          define_attribute :brand_name, name: "Brand" do
            define_formatter do
              # some formatting function
            end
          end

          define_attribute :commune, name: "Commune" do
            define_formatter(opt: 1) do
              # some formatting function
            end
          end
        end

        @attrs = ParserTest.attributes
        @formatter_attr1 = @attrs.first.formatter
        @formatter_attr2 = @attrs.second.formatter
        @formatter_attr3 = @attrs.last.formatter
      end

      it { expect(@formatter_attr1).to be_a(Parxer::Formatter::Number) }
      it { expect(@formatter_attr1.config).to eq(round: 2) }

      it { expect(@formatter_attr2).to be_a(Parxer::Formatter::Custom) }
      it { expect(@formatter_attr2.config.keys).to contain_exactly(:formatter_proc) }

      it { expect(@formatter_attr3).to be_a(Parxer::Formatter::Custom) }
      it { expect(@formatter_attr3.config.keys).to contain_exactly(:opt, :formatter_proc) }
    end

    it "raises error trying to run define_formatter outside of attribute context" do
      expect do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_formatter(:number)
        end
      end.to raise_error(Parxer::DslError, "'define_formatter' needs to run inside 'define_attribute' block")
    end
  end

  describe "#define_after_parse_item_callback" do
    context "with valid callbacks" do
      before do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_after_parse_item_callback(:some_callback)
          define_after_parse_item_callback do
            # some action
          end

          def some_callback
            # do nothing
          end
        end

        @callbacks = ParserTest.parser_callbacks
        @callback1 = @callbacks.first
        @callback2 = @callbacks.second
      end

      it { expect(@callbacks.count).to eq(2) }

      it { expect(@callback1).to be_a(Parxer::Callback) }
      it { expect(@callback1.type).to eq(:after_parse_item) }
      it { expect(@callback1.config).to eq({}) }
      it { expect(@callback1.action).to eq(:some_callback) }

      it { expect(@callback2).to be_a(Parxer::Callback) }
      it { expect(@callback2.type).to eq(:after_parse_item) }
      it { expect(@callback2.config).to eq({}) }
      it { expect(@callback2.action).to be_a(Proc) }
    end

    it "raises error trying to run define_after_parse_item_callback in attribute context" do
      expect do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_attribute :amount, name: "Amount" do
            define_after_parse_item_callback(:some_callback)
          end

          def some_callback
            # do nothing
          end
        end
      end.to raise_error(Parxer::DslError, "'define_after_parse_item_callback' can't run inside 'define_attribute' block")
    end
  end

  context "#define_file_validator" do
    context "with valid definition" do
      before do
        class ParserTest < Parxer::BaseParser
          include Parxer::Dsl

          define_file_validator(:items_count, max: 200)
          define_file_validator(:custom, value: 2) do
            # some condition
          end
        end

        validators = ParserTest.file_validators.last(2)
        @validator1 = validators.first
        @validator2 = validators.last
      end

      it { expect(@validator1).to be_a(Parxer::Validator::ItemsCount) }
      it { expect(@validator1.config[:id]).to eq(:items_count) }
      it { expect(@validator1.config[:max]).to eq(200) }

      it { expect(@validator2).to be_a(Parxer::Validator::Custom) }
      it { expect(@validator2.config[:id]).to eq(:custom) }
      it { expect(@validator2.config[:value]).to eq(2) }
    end
  end
end
