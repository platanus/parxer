module Parxer
  class BaseParser
    include Parxer::ParserInheritedResource
    include Parxer::ParserAttributes
    include Parxer::ParserValidator
    include Parxer::ParserFormatter
    include Parxer::ParserCallback

    attr_reader :file, :value, :attribute, :item

    def run(file)
      @file = file
      return unless validate_file
      item_class = Parxer::ItemBuilder.build(attribute_ids)
      Enumerator.new do |enum|
        for_each_raw_item do |raw_item, idx|
          @item = item_class.new(idx: idx)
          parse_item(raw_item)
          enum << item
        end
      end
    end

    def raw_items
      raise Parxer::ParserError.new("not implemented")
    end

    def extract_raw_attr_value(value)
      value
    end

    def header
      @header ||= raw_items.first
    end

    def items_count
      raw_items.count
    end

    private

    def parse_item(raw_item)
      raw_item.each do |attribute_name, value|
        @value = item.send("#{attribute_name}=", value)
        @attribute = find_attribute(attribute_name)
        format_attribute_value if validate_item_attribute
      end

      after_parse_item
    end

    def for_each_raw_item
      raw_items.each_with_index do |raw_item, idx|
        next if idx.zero?
        yield(raw_item_to_hash(raw_item), idx + 1)
      end
    end

    def raw_item_to_hash(raw_item)
      pos = 0
      attributes.inject({}) do |memo, column|
        memo[column.id.to_sym] = extract_raw_attr_value(raw_item[pos])
        pos += 1
        memo
      end
    end
  end
end
