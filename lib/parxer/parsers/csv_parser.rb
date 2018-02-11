module Parxer
  class CsvParser < Parxer::BaseParser
    validate_file(:file_format, allowed_extensions: [:csv])

    def raw_rows
      csv
    end

    def csv
      @csv ||= Roo::CSV.new(file, csv_options: parser_config)
    end
  end
end
