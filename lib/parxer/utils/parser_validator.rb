module Parxer::ParserValidator
  extend ActiveSupport::Concern

  included do
    def base_errors
      @base_errors ||= Parxer::ItemErrors.new
    end

    def validate_file
      self.class.base_validators.each do |validator|
        next if validator.validate(self)
        base_errors.add_error(:base, validator.id)
      end
    end

    def validate_row
      attribute.validators.each do |validator|
        next if validator.validate(self)
        item.add_error(attribute.id, validator.id)
      end
    end
  end

  class_methods do
    def base_validators
      @base_validators ||= []
    end
  end
end
