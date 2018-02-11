require "spec_helper"

describe Parxer::CsvParser, :csv do
  include_examples :parser, :csv
end
