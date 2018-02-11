module Parxer
  module InheritedResource
    def inherited_collection(object, method_name, collection_class)
      result = collection_class.new

      for_each_ancestor_with_method(object, method_name) do |collection|
        collection.each { |item| result << item }
      end

      result
    end

    def inherited_hash(object, method_name)
      result = {}

      for_each_ancestor_with_method(object, method_name) do |hash|
        result.merge!(hash)
      end

      result
    end

    def for_each_ancestor_with_method(object, method_name, &block)
      object_ancestors(object).each do |klass|
        next unless klass.respond_to?(method_name)
        block.call(klass.send(method_name))
      end
    end

    def object_ancestors(object)
      klass = object.is_a?(Class) ? object : object.class
      klass.ancestors.grep(Class).reverse
    end
  end
end
