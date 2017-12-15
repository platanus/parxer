class Parxer::BooleanValidator < Parxer::BaseValidator
  OPTIONS = ["true", "t", "1", "false", "f", "0"]

  def validate
    v = context.value.to_s
    return true if v.blank?
    OPTIONS.include?(v)
  end
end
