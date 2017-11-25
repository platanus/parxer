class Parxer::BaseValidator
  attr_writer :context
  attr_reader :config

  def initialize(config = {})
    @context = config.delete(:context)
    @config = config
  end

  def id
    self.class.name.demodulize.tableize.singularize.chomp("_validator").to_sym
  end

  def context
    raise Parxer::ValidatorError.new("'context' method not implemented") unless @context
    @context
  end

  def validate
    raise Parxer::ValidatorError.new("'validate' method not implemented")
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
