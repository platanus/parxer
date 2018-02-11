module Parxer
  module RowBuilder
    def self.build(attributes)
      Class.new(Parxer::Row) do
        def self.column_accessor(attribute)
          if method_defined?(attribute)
            raise Parxer::RowError.new("attribute '#{attribute}' already defined")
          end

          attr_accessor(attribute)
        rescue NameError
          raise Parxer::RowError.new("invalid '#{attribute}' method name")
        end

        attributes.each do |attribute|
          column_accessor(attribute)
        end
      end
    end
  end
end
