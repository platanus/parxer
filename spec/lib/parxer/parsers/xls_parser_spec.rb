require "spec_helper"

describe Parxer::XlsParser, :xls do
  context "with xls file" do
    include_examples :parser, :xls
  end

  context "with xlsx file" do
    include_examples :parser, :xlsx
  end
end
