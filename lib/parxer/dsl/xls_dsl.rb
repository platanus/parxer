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
      add_parser_attribute(id, config)
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
    in_context { add_parser_formatter(*params, &block) }
  end

  def after_parse_row(callback_method = nil, &block)
    in_context { add_parser_callback(callback_method, &block) }
  end
end
