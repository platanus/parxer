module Parxer
  module Dsl
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
          msg = if dependencies.any?
                  "'#{current_method}' needs to run inside '#{dependencies.last}' block"
                else
                  "'#{current_method}' can't run inside '#{current_context.last}' block"
                end

          raise Parxer::DslError.new(msg)
        end
      end

      def method_aliases
        @method_aliases ||= {}
      end

      def ctx_dependencies_map
        {
          add_parser_option: [],
          validate_file: [],
          validate_row: [],
          column: [],
          after_parse_row: [],
          validate: [:column],
          format_with: [:column]
        }
      end

      def current_context
        @current_context ||= []
      end

      def column(id, config, &block)
        in_context do
          formatter_name = config.delete(:format)
          @current_attr = attributes.add_attribute(id, name: config.delete(:name))
          format_with(formatter_name) if formatter_name
          block&.call
        end
      ensure
        @current_attr = nil
      end

      def validate(validator_name, config = {}, &block)
        in_context { @current_attr.add_validator(validator_name, config, &block) }
      end

      def validate_file(validator_name, config = {}, &block)
        in_context { add_validator(validator_name, config, &block) }
      end

      def validate_row(validator_name, config = {}, &block)
        in_context { add_row_validator(validator_name, config, &block) }
      end

      def format_with(*params, &block)
        in_context do
          formatter_name = !params.first.is_a?(Hash) ? params.first : :custom
          config = (params.first.is_a?(Hash) ? params.first : params.second) || {}
          @current_attr.add_formatter(formatter_name, config, &block)
        end
      end

      def after_parse_row(callback_method = nil, &block)
        in_context do
          action = callback_method || block
          parser_callbacks.add_callback(:after_parse_row, action)
        end
      end

      def add_parser_option(key, value)
        in_context { add_config_option(key, value) }
      end
    end
  end
end
