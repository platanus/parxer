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
      value
    end

    private

    def worksheet
      @worksheet ||= workbook.sheet(0)
    end

    def workbook
      @workbook ||= Roo::Spreadsheet.open(file, extension: file_ext)
    end

    def file_ext
      file.split(".").last.to_sym
    end
  end
end
