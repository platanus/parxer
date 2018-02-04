class Parxer::ItemErrors < Hash
  def add_error(attribute_name, error)
    self[attribute_name.to_sym] = error
  end

  def attribute_error?(attribute_name)
    !!attribute_error(attribute_name)
  end

  def attribute_error(attribute_name)
    self[attribute_name.to_sym]
  end

  def errors?
    any?
  end
end
