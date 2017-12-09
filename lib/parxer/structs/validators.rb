class Parxer::Validators < Array
  def add_validator(validator_name, config = {}, &block)
    validator = validator_instance(validator_name, config, &block)

    if find_validator(validator.id)
      raise Parxer::ValidatorsError.new("trying to add validator with existent id")
    end

    self << validator
    last
  end

  private

  def find_validator(validator_id)
    find { |validator| validator.id.to_sym == validator_id.to_sym }
  end

  def validator_instance(validator_name, config = {}, &block)
    validator_config = {
      id: validator_name,
      condition_proc: block,
      config: config
    }.merge!(config)

    infer_validator_class(validator_name).new(validator_config)
  end

  def infer_validator_class(validator_name)
    "Parxer::#{validator_name.to_s.camelize}Validator".constantize
  rescue NameError
    Parxer::CustomValidator
  end
end
