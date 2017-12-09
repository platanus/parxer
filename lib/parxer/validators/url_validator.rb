class Parxer::UrlValidator < Parxer::BaseValidator
  def validate
    v = context.value.to_s
    return true if v.blank?
    !!(v =~ URI.regexp)
  end
end
