module Parxer
  module ItemBuilder
    def self.build(attributes)
      Class.new(Parxer::Item) do
        def self.column_accessor(attribute)
          if method_defined?(attribute)
            raise Parxer::ItemError.new("attribute '#{attribute}' already defined")
          end

          attr_accessor(attribute)
        rescue NameError
          raise Parxer::ItemError.new("invalid '#{attribute}' method name")
        end

        attributes.each do |attribute|
          column_accessor(attribute)
        end
      end
    end
  end
end
