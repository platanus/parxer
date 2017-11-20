class Parxer::BaseValidator
  attr_reader :context, :config, :id

  def initialize(config: {})
    @config = config
    @id = self.class.name.demodulize.tableize.singularize.chomp("_validator").to_sym
  end

  def condition
    raise Parxer::ValidatorError.new("'condition' method not implemented")
  end

  def validate(ctx)
    @context = ctx
    !!condition
  end

  def method_missing(method_name, *arguments, &block)
    if context.respond_to?(method_name)
      return context.send(method_name, *arguments, &block)
    end

    super
  end

  def respond_to_missing?(method_name, include_private = false)
    context.respond_to?(method_name) || super
  end
end
