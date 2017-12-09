class Parxer::BooleanValidator < Parxer::BaseValidator
  def validate
    v = context.value.to_s
    return true if v.blank?
    options.include?(v)
  end

  private

  def options
    ["true", "t", "1", "false", "f", "0"]
  end
end
