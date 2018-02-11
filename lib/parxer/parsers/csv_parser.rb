module Parxer
  class CsvParser < Parxer::BaseParser
    include Parxer::Dsl

    def raw_rows
      csv
    end

    def csv
      @csv ||= Roo::CSV.new(file, csv_options: parser_config)
    end
  end
end
