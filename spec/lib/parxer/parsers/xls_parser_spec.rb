require "spec_helper"

describe Parxer::XlsParser, :parser, :xls do
  subject { described_class.new }

  let(:file) { "valid-file.xls" }
  let(:brand_name) { "Platanus" }
  let(:distributor_name) { double }
  let(:address) { double }
  let(:commune) { double }
  let(:region) { double }
  let(:phone) { "3097219-8" }
  let(:custom_validator_value) { commune }

  let(:xls_header) do
    [
      "Marca",
      "Sub Distribuidor",
      "Direccion",
      "Comuna",
      "Region",
      "Telefono"
    ]
  end

  let(:xls_row) do
    [
      brand_name,
      distributor_name,
      address,
      commune,
      region,
      phone
    ]
  end

  let(:perform) { subject.run(file) }

  before do
    mock_spreadsheet_open(file, "valid")

    # Attributes
    add_attribute(:brand_name, name: "Marca")
    add_attribute(:distributor_name, name: "Sub Distribuidor")
    add_attribute(:address, name: "Direccion")
    add_attribute(:commune, name: "Comuna")
    add_attribute(:region, name: "Region")
    add_attribute(:phone, name: "Telefono")

    # Validators
    add_validator(:brand_name, :presence)
    add_validator(:commune, :presence)

    custom_validator_config = {
      condition_proc: Proc.new { value == config[:value] },
      value: custom_validator_value
    }

    add_validator(:commune, :custom, custom_validator_config)

    # File Validators
    add_file_validator(:file_presence)
    add_file_validator(:xls_format)
    add_file_validator(:header_order)

    # Formatters
    custom_formatter_config = {
      formatter_proc: Proc.new { "Hello #{value}!" }
    }

    add_formatter(:brand_name, :custom, custom_formatter_config)
    add_formatter(:phone, :number, integer: true)

    # Callbacks
    callback1 = Proc.new do
      row.brand_name = "#{row.brand_name} :)" unless row.brand_name.blank?
    end

    callback2 = Proc.new do
      row.phone = row.phone * 2 if row.phone
    end

    add_callback(:after_parse_item, callback1)
    add_callback(:after_parse_item, callback2)
  end

  it { expect(subject.valid_file?).to eq(true) }
  it { expect(subject.file).to be_nil }
  it { expect(subject.attribute).to be_nil }
  it { expect(subject.value).to be_nil }
  it { expect(subject.item).to be_nil }

  context "with no file" do
    let(:file) { "" }

    before { perform }

    it { expect(subject.valid_file?).to eq(false) }
    it { expect(subject.file_error).to eq(:file_presence) }
  end

  context "with invalid file format" do
    before do
      mock_spreadsheet_open(file, false)
      perform
    end

    it { expect(subject.valid_file?).to eq(false) }
    it { expect(subject.file_error).to eq(:xls_format) }
  end

  context "with invalid header" do
    let(:xls_header) do
      [
        "Sub Distribuidor",
        "Marca"
      ]
    end

    before { mock_xls_parser_run }

    it { expect(subject.valid_file?).to eq(false) }
    it { expect(subject.file_error).to eq(:header_order) }
  end

  context "with valid parsed item" do
    before { @item = first_parsed_item }

    it { expect(subject.valid_file?).to eq(true) }
    it { expect(@item).to be_a(Parxer::Item) }
    it { expect(@item.errors.blank?).to eq(true) }
    it { expect(@item.idx).to eq(2) }
    it { expect(@item.brand_name).to eq("Hello Platanus! :)") }
    it { expect(@item.distributor_name).to eq(distributor_name) }
    it { expect(@item.address).to eq(address) }
    it { expect(@item.commune).to eq(commune) }
    it { expect(@item.region).to eq(region) }
    it { expect(@item.phone).to eq(6194438) }
  end

  context "when column has errors" do
    let(:brand_name) { "" }

    before { @item = first_parsed_item }

    it { expect(subject.valid_file?).to eq(true) }
    it { expect(@item.brand_name).to eq("") }
    it { expect(@item.errors.count).to eq(1) }
    it { expect(@item.errors[:brand_name]).to eq(:presence) }
  end

  context "when item has errors on multiple attributes" do
    let(:brand_name) { "" }
    let(:commune) { nil }

    before { @item = first_parsed_item }

    it { expect(subject.valid_file?).to eq(true) }
    it { expect(@item.errors.count).to eq(2) }
    it { expect(@item.errors[:brand_name]).to eq(:presence) }
    it { expect(@item.errors[:commune]).to eq(:presence) }
  end

  context "when same attribute has multiple errors" do
    let(:commune) { nil }
    let(:custom_validator_value) { "invalid" }

    before { @item = first_parsed_item }

    it { expect(subject.valid_file?).to eq(true) }
    it { expect(@item.errors.count).to eq(1) }
    it { expect(@item.errors[:commune]).to eq(:presence) }
  end

  context "when attribute with multiple validators has some valid/invalid" do
    let(:custom_validator_value) { "invalid" }

    before { @item = first_parsed_item }

    it { expect(subject.valid_file?).to eq(true) }
    it { expect(@item.errors.count).to eq(1) }
    it { expect(@item.errors[:commune]).to eq(:custom) }
  end
end
