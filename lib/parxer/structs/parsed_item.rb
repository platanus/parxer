class Parxer::ParsedItem
  attr_reader :idx

  def initialize(idx: nil)
    @idx = idx
  end

  def errors
    @errors ||= {}
  end

  def errors?
    errors.any?
  end

  def add_error(attribute_name, error)
    errors[attribute_name.to_sym] = error
  end

  def attribute_errors?(attribute_name)
    errors[attribute_name.to_sym]
  end
end
