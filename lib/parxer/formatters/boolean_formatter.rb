class Parxer::BooleanFormatter < Parxer::BaseFormatter
  TRUE_OPTIONS = ["true", "t", "1"]
  FALSE_OPTIONS = ["false", "f", "0"]

  def format_value(v)
    return true if TRUE_OPTIONS.include?(v)
    return true if FALSE_OPTIONS.include?(v)
  end
end
