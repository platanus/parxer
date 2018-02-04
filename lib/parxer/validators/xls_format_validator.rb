module Parxer
  module Validator
    class XlsFormat < Base
      def validate
        !!Spreadsheet.open(context.file)
      rescue Ole::Storage::FormatError
        false
      end
    end
  end
end
