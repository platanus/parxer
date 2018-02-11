module Parxer
  module ParserFormatter
    extend ActiveSupport::Concern

    included do
      def format_attribute_value
        formatter = attribute.formatter
        return unless formatter
        formatter.context = self
        row.send("#{attribute.id}=", formatter.apply)
      end
    end
  end
end
