class Parxer::AttributeErrors
  attr_accessor :attribute_name

  def initialize(attribute_name)
    @attribute_name = attribute_name.to_sym
  end

  def ==(attr_name)
    return false if attr_name.blank?
    attr_name.to_sym == attribute_name
  end

  def add_error(error)
    errors << error.to_sym
    errors.uniq!
    errors
  end

  def errors
    @errors ||= []
  end
end
