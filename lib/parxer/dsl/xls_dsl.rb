module Parxer::XlsDsl
  extend ActiveSupport::Concern

  class_methods do
    include Parxer::Dsl

    def ctx_dependencies_map
      {
        validate_xls: [],
        column: [],
        validate: [:column],
        format_with: [:column]
      }
    end

    def column(id, config, &block)
      in_context do
        formatter_name = config.delete(:format)
        @current_att = attributes.add_attribute(id, name: config.delete(:name))
        format_with(formatter_name) if formatter_name
        block&.call
      end
    ensure
      @current_att = nil
    end

    def validate(validator_name, config = {}, &block)
      in_context { @current_att.add_validator(validator_name, config, &block) }
    end

    def validate_xls(validator_name, config = {}, &block)
      in_context { add_validator(validator_name, config, &block) }
    end

    def format_with(*params, &block)
      in_context do
        formatter_name = !params.first.is_a?(Hash) ? params.first : :custom
        config = (params.first.is_a?(Hash) ? params.first : params.second) || {}
        @current_att.add_formatter(formatter_name, config, &block)
      end
    end
  end
end
