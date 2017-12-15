class Parxer::BaseFormatter
  include Parxer::Context

  attr_reader :config

  def initialize(config = {})
    @context = config.delete(:context)
    @config = config
  end

  def apply
    v = context.value.to_s

    if v.blank?
      return default_value if default_value?
      return nil
    end

    format_value(v)
  end

  def format_value(_v)
    raise Parxer::FormatterError.new("'format_value' method not implemented")
  end

  private

  def default_value?
    !!default_value
  end

  def default_value
    config[:default]
  end
end
