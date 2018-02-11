module Parxer
  class XlsParser < Parxer::BaseParser
    def raw_rows
      worksheet
    end

    def extract_raw_attr_value(value)
      value.is_a?(Spreadsheet::Formula) ? value.value : value
    end

    def worksheet
      @worksheet ||= workbook.sheet(0)
    end

    def workbook
      @workbook ||= Roo::Spreadsheet.open(file, parser_config)
    end
  end
end
