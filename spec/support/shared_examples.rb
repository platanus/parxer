RSpec.shared_examples :parser do |file_extension|
  let(:file_ext) { file_extension }

  subject { described_class.new }

  let(:file) { "valid-file.#{file_extension}" }
  let(:brand_name) { "Platanus" }
  let(:distributor_name) { "Leandro" }
  let(:address) { "Vespucio 525" }
  let(:commune) { "Carrodilla" }
  let(:region) { "Mendoza" }
  let(:phone) { "3097219-8" }
  let(:custom_validator_value) { commune }

  let(:file_header) do
    [
      "Marca",
      "Sub Distribuidor",
      "Direccion",
      "Comuna",
      "Region",
      "Telefono"
    ]
  end

  let(:file_row) do
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
    mock_file_open(file, "valid")

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

    # Row Validators
    custom_row_validator_config = {
      condition_proc: Proc.new { !!row.region },
      if_valid: [:brand_name]
    }

    add_row_validator(:custom, custom_row_validator_config)

    # File Validators
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

    add_callback(:after_parse_row, callback1)
    add_callback(:after_parse_row, callback2)
  end

  it { expect(subject.valid_file?).to eq(true) }
  it { expect(subject.file).to be_nil }
  it { expect(subject.attribute).to be_nil }
  it { expect(subject.value).to be_nil }
  it { expect(subject.row).to be_nil }
  it { expect(subject.prev_row).to be_nil }
  it { expect(subject.file_extension).to be_nil }

  context "with no file" do
    let(:file) { "" }

    before { perform }

    it { expect(subject.valid_file?).to eq(false) }
    it { expect(subject.file_error).to eq(:file_presence) }
  end

  context "with invalid header" do
    let(:file_header) do
      [
        "Sub Distribuidor",
        "Marca"
      ]
    end

    before { mock_parser_run }

    it { expect(subject.valid_file?).to eq(false) }
    it { expect(subject.file_error).to eq(:header_order) }
  end

  context "with valid parsed row" do
    before { @row = first_parsed_row }

    it { expect(subject.valid_file?).to eq(true) }
    it { expect(subject.file_extension).to eq(file_extension) }
    it { expect(@row).to be_a(Parxer::Row) }
    it { expect(@row.errors.blank?).to eq(true) }
    it { expect(@row.idx).to eq(2) }
    it { expect(@row.brand_name).to eq("Hello Platanus! :)") }
    it { expect(@row.distributor_name).to eq(distributor_name) }
    it { expect(@row.address).to eq(address) }
    it { expect(@row.commune).to eq(commune) }
    it { expect(@row.region).to eq(region) }
    it { expect(@row.phone).to eq(6194438) }
  end

  context "when column has errors" do
    let(:brand_name) { "" }

    before { @row = first_parsed_row }

    it { expect(@row.brand_name).to eq("") }
    it { expect(@row.errors.count).to eq(1) }
    it { expect(@row.errors[:brand_name]).to eq(:presence) }
  end

  context "when row has errors on multiple attributes" do
    let(:brand_name) { "" }
    let(:commune) { nil }

    before { @row = first_parsed_row }

    it { expect(@row.errors.count).to eq(2) }
    it { expect(@row.errors[:brand_name]).to eq(:presence) }
    it { expect(@row.errors[:commune]).to eq(:presence) }
  end

  context "when same attribute has multiple errors" do
    let(:commune) { nil }
    let(:custom_validator_value) { "invalid" }

    before { @row = first_parsed_row }

    it { expect(@row.errors.count).to eq(1) }
    it { expect(@row.errors[:commune]).to eq(:presence) }
  end

  context "when attribute with multiple validators has some valid/invalid" do
    let(:custom_validator_value) { "invalid" }

    before { @row = first_parsed_row }

    it { expect(@row.errors.count).to eq(1) }
    it { expect(@row.errors[:commune]).to eq(:custom) }
  end

  context "working with row validators" do
    let(:region) { nil }

    before { @row = first_parsed_row }

    it { expect(@row.errors.count).to eq(1) }
    it { expect(@row.errors[:base]).to eq(:custom) }

    context "when attribute contained in 'is_valid' option is invalid" do
      let(:brand_name) { nil }

      before { @row = first_parsed_row }

      it { expect(@row.errors.count).to eq(1) }
      it { expect(@row.errors[:brand_name]).to eq(:presence) }
    end
  end
end
