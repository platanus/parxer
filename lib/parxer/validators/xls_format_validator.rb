class Parxer::XlsFormatValidator < Parxer::BaseValidator
  def condition
    !!Spreadsheet.open(context.file)
  rescue Ole::Storage::FormatError
    false
  end
end
