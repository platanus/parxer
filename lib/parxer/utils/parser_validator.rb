module Parxer::ParserValidator
  extend ActiveSupport::Concern

  included do
    attr_reader :file_error

    def valid_file?
      !file_error
    end

    def validate_file
      self.class.base_validators.each do |validator|
        next unless valid_file?
        validator.context = self
        next if validator.validate
        @file_error = validator.id
      end
    end

    def validate_row
      attribute.validators.each do |validator|
        validator.context = self
        next if item.attribute_errors?(attribute.id) || validator.validate
        item.add_error(attribute.id, validator.id)
      end
    end
  end

  class_methods do
    def add_base_validator(validator)
      base_validators << validator
    end

    def base_validators
      @base_validators ||= []
    end
  end
end
