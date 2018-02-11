module Parxer
  class BaseParser
    include Parxer::InheritedResource
    include Parxer::ParserConfig
    include Parxer::ParserAttributes
    include Parxer::ParserValidator
    include Parxer::ParserFormatter
    include Parxer::ParserCallback
    include Parxer::Dsl

    attr_reader :file, :value, :attribute, :row, :prev_row

    validate_file(:file_presence)
    validate_file(:file_format)

    def run(file)
      @file = file
      return unless validate_file
      row_class = Parxer::RowBuilder.build(attribute_ids)
      Enumerator.new do |enum|
        for_each_raw_row do |raw_row, idx|
          @row = row_class.new(idx: idx)
          parse_row(raw_row)
          enum << row
          @prev_row = row
        end
      end
    end

    def raw_rows
      raise Parxer::ParserError.new("not implemented")
    end

    def extract_raw_attr_value(value)
      value
    end

    def header
      @header ||= raw_rows.first
    end

    def rows_count
      raw_rows.count
    end

    def file_extension
      ext = File.extname(file.to_s).delete(".")
      return if ext.blank?
      ext.to_sym
    end

    private

    def parse_row(raw_row)
      raw_row.each do |attribute_name, value|
        @value = row.send("#{attribute_name}=", value)
        @attribute = find_attribute(attribute_name)
        format_attribute_value if validate_row_attribute
      end

      after_parse_row
    end

    def for_each_raw_row
      raw_rows.each_with_index do |raw_row, idx|
        next if idx.zero?
        yield(raw_row_to_hash(raw_row), idx + 1)
      end
    end

    def raw_row_to_hash(raw_row)
      pos = 0
      attributes.inject({}) do |memo, column|
        memo[column.id.to_sym] = extract_raw_attr_value(raw_row[pos])
        pos += 1
        memo
      end
    end
  end
end
