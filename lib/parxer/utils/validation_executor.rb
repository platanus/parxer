module Parxer::ValidationExecutor
  def self.execute(attribute, parsed_item, parser)
    attribute.validators.each do |validator|
      validate(attribute.id, parsed_item, parser, validator)
    end
  end

  def self.validate(attribute_id, parsed_item, parser, validator)
    return if validator.validate(parser)
    parsed_item.add_error(attribute_id, validator.id)
  end
end
