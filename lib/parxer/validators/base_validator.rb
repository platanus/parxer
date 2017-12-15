class Parxer::BaseValidator
  include Parxer::Context

  attr_reader :config

  def initialize(config = {})
    @context = config.delete(:context)
    @config = config
  end

  def id
    self.class.name.demodulize.tableize.singularize.chomp("_validator").to_sym
  end

  def validate
    raise Parxer::ValidatorError.new("'validate' method not implemented")
  end
end
