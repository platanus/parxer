module Parxer
  module RowBuilder
    def self.build(attributes)
      Class.new(Parxer::Row) do
        def self.column_accessor(attribute)
          attr_accessor(attribute) unless method_defined?(attribute)
        rescue NameError
          raise Parxer::RowError.new("invalid '#{attribute}' method name")
        end

        def add_attribute(attribute, value = nil)
          self.class.column_accessor(attribute)
          send("#{attribute}=", value) if value
        end

        attributes.each do |attribute|
          column_accessor(attribute)
        end
      end
    end
  end
end
