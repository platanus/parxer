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
end
