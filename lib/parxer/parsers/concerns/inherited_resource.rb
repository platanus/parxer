module Parxer
  module ParserInheritedResource
    extend ActiveSupport::Concern

    included do
      def inherited_resource(method, collection_class)
        result = collection_class.new
        base_found = false

        self.class.ancestors.grep(Class).reverse.each do |parser_klass|
          base_found = true if parser_klass == Parxer::BaseParser
          next unless base_found
          parser_klass.send(method).each { |item| result << item }
        end

        result
      end
    end
  end
end
