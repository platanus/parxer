require "spec_helper"

RSpec.describe Parxer::CsvDsl do
  describe "#method_aliases" do
    before do
      class ParserTest
        include Parxer::CsvDsl
      end
    end

    it "returns valid method aliases" do
      result = {
        define_file_validator: :validate_csv,
        define_attribute: :column,
        define_after_parse_item_callback: :after_parse_row,
        define_attribute_validator: :validate,
        define_formatter: :format_with
      }

      expect(ParserTest.method_aliases).to eq(result)
    end
  end
end
