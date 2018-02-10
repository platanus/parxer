module Parxer
  class Attributes < Array
    def add_attribute(id, name: nil)
      if find_attribute(id)
        raise Parxer::AttributesError.new("trying to add attribute with existent id")
      end

      self << Parxer::Attribute.new(id, name: name)
      last
    end

    def find_attribute(attribute_id)
      find { |attribute| attribute.id == attribute_id.to_sym }
    end
  end
end
