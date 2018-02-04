module Parxer::FormatterBuilder
  def self.build(formatter_name, config = {}, &block)
    formatter_class = infer_formatter_class(formatter_name)
    config[:formatter_proc] = block if formatter_class == Parxer::Formatter::Custom
    formatter_class.new(config)
  end

  def self.infer_formatter_class(formatter_name)
    return Parxer::Formatter::Custom if formatter_name.blank?
    "Parxer::Formatter::#{formatter_name.to_s.camelize}".constantize
  rescue NameError
    Parxer::Formatter::Custom
  end
end
