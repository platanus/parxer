class Parxer::XlsFormatValidator < Parxer::BaseValidator
  def validate
    !!Spreadsheet.open(context.file)
  rescue Ole::Storage::FormatError
    false
  end
end
