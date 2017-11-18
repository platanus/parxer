class Parxer::BaseValidator
  attr_reader :context

  def condition
    raise Parxer::ValidatorError.new("'condition' method not implemented")
  end

  def validate(ctx)
    @context = ctx
    !!condition
  end

  def value
    call_context_method(:value)
  end

  def item
    call_context_method(:item)
  end

  def call_context_method(method_name)
    if !context.respond_to?(method_name)
      raise Parxer::ValidatorError.new(
        "given context #{context} does not respond to '#{method_name}'"
      )
    end

    context.send(method_name)
  end
end
