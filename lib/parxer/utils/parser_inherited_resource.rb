module Parxer::ParserInheritedResource
  extend ActiveSupport::Concern

  included do
    def inherited_resource(method, collection_class)
      result = collection_class.new

      self.class.ancestors.reverse.each do |parser_module|
        next unless parser_module.respond_to?(method)
        parser_module.send(method).each { |item| result << item }
      end

      result
    end
  end
end
