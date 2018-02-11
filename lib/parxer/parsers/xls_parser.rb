module Parxer
  class XlsParser < Parxer::BaseParser
    include Parxer::Dsl

    def raw_rows
      worksheet
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
