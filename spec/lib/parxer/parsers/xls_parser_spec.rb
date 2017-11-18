require "spec_helper"

describe Parxer::XlsParser, :xls do
  def perform
    described_class.new(file).run
  end

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
    [
      double(id: :brand_name, name: "Marca"),
      double(id: :distributor_name, name: "Sub Distribuidor"),
      double(id: :address, name: "Direccion"),
      double(id: :commune, name: "Comuna"),
      double(id: :region, name: "Region"),
      double(id: :phone, name: "Telefono")
    ]
  end

  context "with parsed xls" do
    before { @item = first_parsed_item }

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
end
