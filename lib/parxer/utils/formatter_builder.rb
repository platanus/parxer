module Parxer::FormatterBuilder
  def self.build(formatter_name, config = {}, &block)
    formatter_class = infer_formatter_class(formatter_name)
    config[:formatter_proc] = block if formatter_class == Parxer::CustomFormatter
    formatter_class.new(config)
  end

  def self.infer_formatter_class(formatter_name)
    "Parxer::#{formatter_name.to_s.camelize}Formatter".constantize
  rescue NameError
    Parxer::CustomFormatter
  end
end
