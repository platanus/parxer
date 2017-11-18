module XlsHelpers
  def mock_worksheet_content(content, times = 1)
    expect_any_instance_of(described_class).to(
      receive(:worksheet).exactly(times).times.and_return(content)
    )
  end

  def mock_parser_attributes(content, times = 1)
    expect(described_class).to(
      receive(:attributes).exactly(times).times.and_return(content)
    )
  end

  def first_parsed_item
    xls_content = [xls_header, xls_row]
    mock_worksheet_content(xls_content)
    mock_parser_attributes(parser_attributes, 2)
    perform.first
  end
end

RSpec.configure do |config|
  config.include XlsHelpers, :xls
end
