module Parxer::ItemBuilder
  def self.build(attributes)
    Class.new(Parxer::Item) do
      def self.define_attribute_accessor(attribute)
        if method_defined?(attribute)
          raise Parxer::ItemError.new("attribute '#{attribute}' already defined")
        end

        attr_accessor(attribute)
      rescue NameError
        raise Parxer::ItemError.new("invalid '#{attribute}' method name")
      end

      attributes.each do |attribute|
        define_attribute_accessor(attribute)
      end
    end
  end
end
