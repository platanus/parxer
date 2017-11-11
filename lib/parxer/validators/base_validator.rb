class Parxer::BaseValidator
  attr_reader :context

  def initialize(context)
    @context = context
  end

  def validator
    raise Parxer::ValidatorError.new("'validator' method not implemented")
  end

  def validate(item, value)
    !!context.instance_exec(item, value, &validator)
  end
end
