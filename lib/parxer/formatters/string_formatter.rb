class Parxer::StringFormatter < Parxer::BaseValidator
  def format_value
    context.value.to_s
  end
end
