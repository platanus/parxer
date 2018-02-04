class Parxer::Validators < Array
  def add_validator(validator_name, config = {}, &block)
    validator = validator_instance(validator_name, config, &block)

    if find_validator(validator.id)
      raise Parxer::ValidatorError.new("trying to add validator with existent id")
    end

    self << validator
    last
  end

  private

  def find_validator(validator_id)
    find { |validator| validator.id.to_sym == validator_id.to_sym }
  end

  def validator_instance(validator_name, config = {}, &block)
    config[:id] = validator_name
    validator_class = infer_validator_class(validator_name)
    config[:condition_proc] = block if validator_class == Parxer::CustomValidator
    validator_class.new(config)
  end

  def infer_validator_class(validator_name)
    "Parxer::#{validator_name.to_s.camelize}Validator".constantize
  rescue NameError
    Parxer::CustomValidator
  end
end
