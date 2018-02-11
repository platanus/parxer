module Parxer
  module Validator
    class FileFormat < Base
      def validate
        validate_file_extension
        validate_format
      end

      private

      def validate_file_extension
        raise Parxer::ValidatorError.new("file without extension") if context.file_extension.blank?
      end

      def validate_format
        if context.is_a?(Parxer::XlsParser)
          validate_xls_format
        elsif context.is_a?(Parxer::CsvParser)
          validate_csv_format
        else
          raise Parxer::ValidatorError.new("unknown parxer class")
        end
      end

      def validate_xls_format
        return false unless [:xls, :xlsx].include?(context.file_extension)
        !!context.worksheet
      rescue
        false
      end

      def validate_csv_format
        return false unless [:csv].include?(context.file_extension)
        !!context.csv
      rescue
        false
      end
    end
  end
end
