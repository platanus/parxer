module Parxer::ParserValidator
  extend ActiveSupport::Concern

  included do
    def base_errors
      @base_errors.try(:errors) || []
    end

    def valid_file?
      base_errors.none?
    end

    def validate_file
      self.class.base_validators.each do |validator|
        next if !valid_file? || validator.validate(self)
        @base_errors ||= Parxer::AttributeErrors.new(:base)
        @base_errors.add_error(validator.id)
      end
    end

    def validate_row
      attribute.validators.each do |validator|
        next if item.attribute_errors?(attribute.id) || validator.validate(self)
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
