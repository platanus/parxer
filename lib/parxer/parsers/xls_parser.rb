class Parxer::XlsParser
  extend Parxer::XlsDsl

  attr_reader :file

  def initialize(file)
    @file = file
  end

  def run
    item_class = Parxer::ParsedItemBuilder.build(column_names)
    Enumerator.new do |enum|
      for_each_xls_row do |row, idx|
        enum << parse_row(item_class, row, idx)
      end
    end
  end

  def item
    @item
  end

  def value
    @value
  end

  def self.attributes
    @attributes ||= Parxer::Attributes.new
  end

  private

  def column_names
    self.class.attributes.map(&:id)
  end

  def parse_row(item_class, row, idx)
    @item = item_class.new(idx: idx)

    row.each do |column_name, value|
      @value = @item.send("#{column_name}=", value)
      attribute = self.class.attributes.find_attribute(column_name)
      Parxer::ValidationExecutor.execute(attribute, @item, self)
    end

    @item
  end

  def for_each_xls_row
    worksheet.each_with_index do |row, idx|
      next if idx.zero?
      yield(row_to_hash(row), idx + 1)
    end
  end

  def row_to_hash(row)
    pos = 0
    self.class.attributes.inject({}) do |memo, column|
      memo[column.id.to_sym] = extract_row_value(row, pos)
      pos += 1
      memo
    end
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
