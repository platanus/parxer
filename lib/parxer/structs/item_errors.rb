class Parxer::ItemErrors < Array
  def add_error(attribute_name, error)
    find_or_create_attr_errors(attribute_name).add_error(error)
  end

  def attribute_errors?(attribute_name)
    !!find_attr_errors(attribute_name)
  end

  private

  def find_or_create_attr_errors(attribute_name)
    attr_errors = find_attr_errors(attribute_name)
    return attr_errors if attr_errors
    self << Parxer::AttributeErrors.new(attribute_name)
    last
  end

  def find_attr_errors(attribute_name)
    find { |attr_errors| attr_errors == attribute_name }
  end
end
