class Parxer::XlsParser < Parxer::BaseParser
  extend Parxer::XlsDsl

  def raw_rows
    worksheet
  end

  def extract_row_value(row, pos)
    row[pos].is_a?(Spreadsheet::Formula) ? row[pos].value : row[pos]
  end

  def worksheet
    @worksheet ||= workbook.worksheet(0)
  end

  def workbook
    @workbook ||= Spreadsheet.open(file)
  end
end
