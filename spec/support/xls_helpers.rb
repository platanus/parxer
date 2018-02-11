module XlsHelpers
  def mock_spreadsheet_open(file, response)
    allow(Spreadsheet).to receive(:open).with(file).and_return(response)
  end

  def mock_worksheet_content(content)
    allow_any_instance_of(described_class).to receive(:worksheet).and_return(content)
  end

  def mock_xls_parser_run
    xls_content = [xls_header, xls_row]
    mock_worksheet_content(xls_content)
    perform
  end

  def first_parsed_row
    mock_xls_parser_run.first
  end
end

RSpec.configure do |config|
  config.include XlsHelpers, :xls
end
