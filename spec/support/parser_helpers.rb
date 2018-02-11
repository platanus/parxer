module ParserHelpers
  def add_validator(attribute_name, validator_name, config = {})
    attribute = subject.attributes.find_attribute(attribute_name)

    if validator_name == :custom
      condition_proc = config.delete(:condition_proc)
      attribute.add_validator(:custom, config, &condition_proc)
    else
      attribute.add_validator(validator_name, config)
    end
  end

  def add_formatter(attribute_name, formatter_name, config = {})
    attribute = subject.attributes.find_attribute(attribute_name)

    if formatter_name == :custom
      formatter_proc = config.delete(:formatter_proc)
      attribute.add_formatter(:custom, config, &formatter_proc)
    else
      attribute.add_formatter(formatter_name, config)
    end
  end

  def add_attribute(id, name: nil)
    subject.attributes.add_attribute(id, name: name)
  end

  def add_file_validator(validator_name)
    subject.file_validators.add_validator(validator_name)
  end

  def add_callback(type, action)
    subject.parser_callbacks.add_callback(type: type, action: action)
  end

  def mock_file_open(_file, _response)
    raise "not implemented"
  end

  def mock_file_content(_content)
    raise "not implemented"
  end

  def mock_parser_run
    xls_content = [file_header, file_row]
    mock_file_content(xls_content)
    perform
  end

  def first_parsed_row
    mock_parser_run.first
  end
end

module CsvHelpers
  include ::ParserHelpers

  def mock_file_open(file, response)
    allow(Roo::CSV).to receive(:new).with(file, kind_of(hash)).and_return(response)
  end

  def mock_file_content(content)
    allow_any_instance_of(described_class).to receive(:csv).and_return(content)
  end
end

module XlsHelpers
  include ::ParserHelpers

  def mock_file_open(file, response)
    allow(Spreadsheet).to receive(:open).with(file).and_return(response)
  end

  def mock_file_content(content)
    allow_any_instance_of(described_class).to receive(:worksheet).and_return(content)
  end
end

RSpec.configure do |config|
  config.include XlsHelpers, :xls
  config.include CsvHelpers, :csv
end
