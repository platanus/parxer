class Parxer::XlsFormatValidator < Parxer::BaseValidator
  def condition
    !!Spreadsheet.open(file)
  rescue Ole::Storage::FormatError
    false
  end
end
