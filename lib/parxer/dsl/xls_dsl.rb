module Parxer::XlsDsl
  def column(id, name: nil)
    raise Parxer::XlsDslError.new("nest column is not allowed") if @current_att
    @current_att = attributes.add_attribute(id, name: name)
    yield if block_given?
  ensure
    @current_att = nil
  end

  def validate(validator_name, config = {}, &block)
    raise Parxer::XlsDslError.new("validate needs to run in column context") unless @current_att
    @current_att.add_validator(validator_name, config, &block)
  end

  def validate_xls(validator_name, config = {}, &block)
    raise Parxer::XlsDslError.new("validate_xls needs to run out of column context") if @current_att
    add_validator(validator_name, config, &block)
  end
end
