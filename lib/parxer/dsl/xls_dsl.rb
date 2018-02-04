module Parxer::XlsDsl
  include Parxer::Dsl

  def ctx_dependencies_map
    {
      validate_xls: [],
      column: [],
      after_parse_row: [],
      validate: [:column],
      format_with: [:column]
    }
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

  def validate_xls(validator_name, config = {}, &block)
    in_context { add_validator(validator_name, config, &block) }
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
      parser_callbacks.add_callback(type: :after_parse_item, action: action)
    end
  end
end
