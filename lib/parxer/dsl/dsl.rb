module Parxer::Dsl
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

  def ctx_dependencies_map
    raise Parxer::DslError.new("'ctx_dependencies_map' method not implemented")
  end

  def current_context
    @current_context ||= []
  end

  def add_parser_attribute(id, config)
    formatter_name = config.delete(:format)
    @current_attr = attributes.add_attribute(id, name: config.delete(:name))
    format_with(formatter_name) if formatter_name
  end

  def add_parser_formatter(*params, &block)
    formatter_name = !params.first.is_a?(Hash) ? params.first : :custom
    config = (params.first.is_a?(Hash) ? params.first : params.second) || {}
    @current_attr.add_formatter(formatter_name, config, &block)
  end

  def add_parser_callback(callback_method = nil, &block)
    action = callback_method || block
    parser_callbacks.add_callback(type: :after_parse_item, action: action)
  end
end
