module ParserHelpers
  def add_validator(attribute_name, validator_name, config = {})
    attribute = subject.attributes.find_attribute(attribute_name)

    if validator_name == :custom
      condition_proc = config.delete(:condition_proc)
      attribute.add_validator(:custom, config, &condition_proc)
    else
      attribute.add_validator(validator_name, config)
    end
  end

  def add_formatter(attribute_name, formatter_name, config = {})
    attribute = subject.attributes.find_attribute(attribute_name)

    if formatter_name == :custom
      formatter_proc = config.delete(:formatter_proc)
      attribute.add_formatter(:custom, config, &formatter_proc)
    else
      attribute.add_formatter(formatter_name, config)
    end
  end

  def add_attribute(id, name: nil)
    subject.attributes.add_attribute(id, name: name)
  end

  def add_file_validator(validator_name)
    subject.file_validators.add_validator(validator_name)
  end

  def add_callback(type, action)
    subject.parser_callbacks.add_callback(type: type, action: action)
  end
end

RSpec.configure do |config|
  config.include ParserHelpers, :parser
end
