class Parxer::Attributes < Array
  def add_attribute(id, name: nil)
    self << Parxer::Attribute.new(id, name: name)
    last
  end

  def add_validator(attribute_id, validator)
    attribute = find_attribute(attribute_id)

    if !attribute
      raise Parxer::AttributesError.new("trying to add validator on non existent attribute")
    end

    attribute.validators << validator
  end

  def find_attribute(attribute_id)
    find { |attribute| attribute.id == attribute_id.to_sym }
  end
end
