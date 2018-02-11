module Parxer
  module ParserValidator
    extend ActiveSupport::Concern

    included do
      attr_reader :file_error

      def file_validators
        @file_validators ||= inherited_collection(self, :file_validators, Parxer::Validators)
      end

      def row_validators
        @row_validators ||= inherited_collection(self, :row_validators, Parxer::Validators)
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

        valid_file?
      end

      def validate_row
        row_validators.each do |validator|
          validator.context = self
          next if !validate_row?(validator) || validator.validate
          row.add_error(:base, validator.id)
        end

        !row.errors?
      end

      def validate_row?(validator)
        attrs = validator.config[:if_valid]
        return !row.errors? if attrs.blank?
        attrs.select { |a| row.attribute_error?(a) }.none?
      end

      def validate_row_attribute
        attribute.validators.each do |validator|
          validator.context = self
          next if row.attribute_error?(attribute.id) || validator.validate
          row.add_error(attribute.id, validator.id)
        end

        !row.attribute_error?(attribute.id)
      end
    end

    class_methods do
      def file_validators
        @file_validators ||= Parxer::Validators.new
      end

      def add_validator(validator_name, config, &block)
        file_validators.add_validator(validator_name, config, &block)
      end

      def row_validators
        @row_validators ||= Parxer::Validators.new
      end

      def add_row_validator(validator_name, config, &block)
        row_validators.add_validator(validator_name, config, &block)
      end
    end
  end
end
