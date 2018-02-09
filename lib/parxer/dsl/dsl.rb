module Parxer::Dsl
  extend ActiveSupport::Concern

  class_methods do
    def in_context
      current_method = caller_locations(1, 1)[0].label.to_sym
      validate_context!(current_method)
      current_context << current_method
      yield
    ensure
      current_context.pop
    end

    def validate_context!(current_method)
      dependencies = ctx_dependencies_map[current_method]

      if current_context != dependencies
        cm = alias_or_method(current_method)
        msg = if dependencies.any?
                "'#{cm}' needs to run inside '#{alias_or_method(dependencies.last)}' block"
              else
                "'#{cm}' can't run inside '#{alias_or_method(current_context.last)}' block"
              end

        raise Parxer::DslError.new(msg)
      end
    end

    def define_alias_method(parser_class, generic_method_name, specific_method_name)
      method_aliases[generic_method_name.to_sym] = specific_method_name.to_sym
      parser_class.singleton_class.send(:alias_method, specific_method_name, generic_method_name)
    end

    def method_aliases
      @method_aliases ||= {}
    end

    def ctx_dependencies_map
      {
        define_file_validator: [],
        define_attribute: [],
        define_after_parse_item_callback: [],
        define_attribute_validator: [:define_attribute],
        define_formatter: [:define_attribute]
      }
    end

    def current_context
      @current_context ||= []
    end

    def alias_or_method(method_name)
      inherited_method_aliases[method_name.to_sym] || method_name
    end

    def inherited_method_aliases
      result = {}
      base_found = false

      ancestors.grep(Class).reverse.each do |parser_klass|
        base_found = true if parser_klass == Parxer::BaseParser
        next if !base_found || !parser_klass.respond_to?(:method_aliases)
        parser_klass.method_aliases.each { |k, v| result[k] = v }
      end

      result
    end

    def define_attribute(id, config, &block)
      in_context do
        formatter_name = config.delete(:format)
        @current_attr = attributes.add_attribute(id, name: config.delete(:name))
        define_formatter(formatter_name) if formatter_name
        block&.call
      end
    ensure
      @current_attr = nil
    end

    def define_attribute_validator(validator_name, config = {}, &block)
      in_context { @current_attr.add_validator(validator_name, config, &block) }
    end

    def define_file_validator(validator_name, config = {}, &block)
      in_context { add_validator(validator_name, config, &block) }
    end

    def define_formatter(*params, &block)
      in_context do
        formatter_name = !params.first.is_a?(Hash) ? params.first : :custom
        config = (params.first.is_a?(Hash) ? params.first : params.second) || {}
        @current_attr.add_formatter(formatter_name, config, &block)
      end
    end

    def define_after_parse_item_callback(callback_method = nil, &block)
      in_context { define_parser_callback(callback_method, &block) }
    end

    def define_parser_callback(callback_method = nil, &block)
      action = callback_method || block
      parser_callbacks.add_callback(type: :after_parse_item, action: action)
    end
  end
end
