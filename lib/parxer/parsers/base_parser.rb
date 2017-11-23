class Parxer::BaseParser
  attr_reader :file, :value, :attribute, :item

  def initialize(file)
    @file = file
  end

  def run
    item_class = Parxer::ParsedItemBuilder.build(column_names)
    Enumerator.new do |enum|
      for_each_row do |row, idx|
        @item = item_class.new(idx: idx)
        parse_row(row)
        enum << item
      end
    end
  end

  def rows_count
    raw_rows.count
  end

  def self.attributes
    @attributes ||= Parxer::Attributes.new
  end

  private

  def raw_rows
    raise Parxer::ParserError.new("not implemented")
  end

  def extract_row_value(row, pos)
    row[pos]
  end

  def column_names
    self.class.attributes.map(&:id)
  end

  def parse_row(row)
    row.each do |column_name, value|
      @value = item.send("#{column_name}=", value)
      @attribute = self.class.attributes.find_attribute(column_name)
      validate_row
    end
  end

  def validate_row
    attribute.validators.each do |validator|
      next if validator.validate(self)
      item.add_error(attribute.id, validator.id)
    end
  end

  def for_each_row
    raw_rows.each_with_index do |row, idx|
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
end
