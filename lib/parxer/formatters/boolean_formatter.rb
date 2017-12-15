class Parxer::BooleanFormatter < Parxer::BaseValidator
  TRUE_OPTIONS = ["true", "t", "1"]
  FALSE_OPTIONS = ["false", "f", "0"]

  def format_value
    v = context.value.to_s
    return true if TRUE_OPTIONS.include?(v)
    return true if FALSE_OPTIONS.include?(v)
  end
end
