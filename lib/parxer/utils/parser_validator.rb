module Parxer::ParserValidator
  extend ActiveSupport::Concern

  included do
    attr_reader :file_error

    def file_validators
      self.class.file_validators
    end

    def valid_file?
      !file_error
    end

    def validate_file
      file_validators.each do |validator|
        validator.context = self
        next if !valid_file? || validator.validate
        @file_error = validator.id
      end
    end

    def validate_item_attribute
      attribute.validators.each do |validator|
        validator.context = self
        next if item.attribute_error?(attribute.id) || validator.validate
        item.add_error(attribute.id, validator.id)
      end
    end
  end

  class_methods do
    def file_validators
      @file_validators ||= Parxer::Validators.new
    end

    def add_validator(validator_name, config, &block)
      file_validators.add_validator(validator_name, config, &block)
    end
  end
end
