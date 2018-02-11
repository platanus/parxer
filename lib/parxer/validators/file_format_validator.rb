module Parxer
  module Validator
    class FileFormat < Base
      def validate
        return false unless allowed_extensions.include?(context.file_extension)
        !!context.raw_rows
      rescue
        false
      end

      private

      def allowed_extensions
        config[:allowed_extensions].map(&:to_sym)
      end
    end
  end
end
