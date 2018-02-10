module Parxer
  class XlsParser < Parxer::BaseParser
    include Parxer::XlsDsl

    def raw_items
      worksheet
    end

    def row
      item
    end

    def prev_row
      prev_item
    end

    def extract_raw_attr_value(value)
      value.is_a?(Spreadsheet::Formula) ? value.value : value
    end

    def worksheet
      @worksheet ||= workbook.worksheet(0)
    end

    def workbook
      @workbook ||= Spreadsheet.open(file)
    end
  end
end
