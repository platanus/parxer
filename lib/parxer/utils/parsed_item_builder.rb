module Parxer::ParsedItemBuilder
  def self.build(attributes)
    Class.new(Parxer::ParsedItem) do
      def self.define_attribute_accessor(attribute)
        if method_defined?(attribute)
          raise Parxer::ParsedItemError.new("attribute '#{attribute}' already defined")
        end

        attr_accessor(attribute)
      rescue NameError
        raise Parxer::ParsedItemError.new("invalid '#{attribute}' method name")
      end

      attributes.each do |attribute|
        define_attribute_accessor(attribute)
      end
    end
  end
end
