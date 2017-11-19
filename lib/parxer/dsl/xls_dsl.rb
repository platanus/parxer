module Parxer::XlsDsl
  def column(id, name: nil)
    raise Parxer::XlsDslError.new("nest column is not allowed") if @current_att
    @current_att = attributes.add_attribute(id, name: name)
    yield if block_given?
  ensure
    @current_att = nil
  end

  def validate(validator_name, &block)
    raise Parxer::XlsDslError.new("validate needs to run in column context") unless @current_att

    validator_class = infer_validator_class(validator_name)
    validator = if validator_class == Parxer::CustomValidator
                  validator_class.new(validator_name, block)
                else
                  validator_class.new
                end

    @current_att.validators << validator
  end

  def infer_validator_class(validator_name)
    "Parxer::#{validator_name.to_s.classify}Validator".constantize
  rescue NameError
    Parxer::CustomValidator
  end
end
