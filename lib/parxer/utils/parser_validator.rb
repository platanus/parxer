module Parxer::ParserValidator
  extend ActiveSupport::Concern

  included do
    attr_reader :file_error

    def valid_file?
      !file_error
    end

    def validate_file
      self.class.file_validators.each do |validator|
        validator.context = self
        next if !valid_file? || validator.validate
        @file_error = validator.id
      end
    end

    def validate_row
      attribute.validators.each do |validator|
        validator.context = self
        next if item.attribute_error?(attribute.id) || validator.validate
        item.add_error(attribute.id, validator.id)
      end
    end
  end

  class_methods do
    def add_file_validator(validator)
      file_validators << validator
    end

    def file_validators
      @file_validators ||= []
    end
  end
end
