require "spec_helper"

describe Parxer::XlsParser, :xls do
  subject { described_class.new(file) }

  let(:file) { "valid-file.xls" }
  let(:brand_name) { double }
  let(:distributor_name) { double }
  let(:address) { double }
  let(:commune) { double }
  let(:region) { double }
  let(:phone) { double }

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

  let(:parser_attributes) do
    pa = Parxer::Attributes.new
    pa.add_attribute(:brand_name, name: "Marca")
    pa.add_attribute(:distributor_name, name: "Sub Distribuidor")
    pa.add_attribute(:address, name: "Direccion")
    pa.add_attribute(:commune, name: "Comuna")
    pa.add_attribute(:region, name: "Region")
    pa.add_attribute(:phone, name: "Telefono")
    pa
  end

  let(:perform) { subject.run }

  before { allow(Spreadsheet).to receive(:open).with(file).and_return("valid") }

  it { expect(subject.valid_file?).to eq(true) }
  it { expect(subject.file).to eq(file) }
  it { expect(subject.attribute).to be_nil }
  it { expect(subject.value).to be_nil }
  it { expect(subject.item).to be_nil }

  context "with parsed xls" do
    before { @item = first_parsed_item }

    it { expect(subject.valid_file?).to eq(true) }
    it { expect(@item).to be_a(Parxer::ParsedItem) }
    it { expect(@item.errors.blank?).to eq(true) }
    it { expect(@item.idx).to eq(2) }
    it { expect(@item.brand_name).to eq(brand_name) }
    it { expect(@item.distributor_name).to eq(distributor_name) }
    it { expect(@item.address).to eq(address) }
    it { expect(@item.commune).to eq(commune) }
    it { expect(@item.region).to eq(region) }
    it { expect(@item.phone).to eq(phone) }
  end

  context "with no file" do
    let(:file) { "" }

    before { perform }

    it { expect(subject.valid_file?).to eq(false) }
    it { expect(subject.base_errors.count).to eq(1) }
    it { expect(subject.base_errors.first).to eq(:file_required) }
  end

  context "with invalid file format" do
    before do
      allow(Spreadsheet).to receive(:open).with(file).and_return(false)
      perform
    end

    before { perform }

    it { expect(subject.valid_file?).to eq(false) }
    it { expect(subject.base_errors.count).to eq(1) }
    it { expect(subject.base_errors.first).to eq(:xls_format) }
  end
end
