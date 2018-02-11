module Parxer
  module ParserAttributes
    extend ActiveSupport::Concern

    included do
      def attribute_ids
        attributes.map(&:id)
      end

      def attributes
        @attributes ||= inherited_collection(self, :attributes, Parxer::Attributes)
      end

      def find_attribute(attribute_name)
        attributes.find_attribute(attribute_name)
      end
    end

    class_methods do
      def attributes
        @attributes ||= Parxer::Attributes.new
      end
    end
  end
end
