class Parxer::BaseFormatter
  include Parxer::Context

  attr_reader :config

  def initialize(config = {})
    @context = config.delete(:context)
    @config = config
  end

  def format_value
    raise Parxer::FormatterError.new("'format_value' method not implemented")
  end
end
