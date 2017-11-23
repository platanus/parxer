module XlsHelpers
  def mock_spreadsheet_open(file, response)
    allow(Spreadsheet).to receive(:open).with(file).and_return(response)
  end

  def mock_worksheet_content(content)
    allow_any_instance_of(described_class).to receive(:worksheet).and_return(content)
  end

  def mock_parser_attributes(content)
    allow(described_class).to receive(:attributes).and_return(content)
  end

  def mock_xls_parser_run
    xls_content = [xls_header, xls_row]
    mock_worksheet_content(xls_content)
    mock_parser_attributes(parser_attributes)
    perform
  end

  def first_parsed_item
    mock_xls_parser_run.first
  end

  def add_validator(attribute_name, validator)
    attribute = parser_attributes.find_attribute(attribute_name)
    attribute.validators << validator
  end
end

RSpec.configure do |config|
  config.include XlsHelpers, :xls
end
