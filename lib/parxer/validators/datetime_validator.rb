class Parxer::DatetimeValidator < Parxer::BaseValidator
  def validate
    v = context.value.to_s
    return true if v.blank?
    return false unless valid_datetime?(v)
    return false unless valid_format?(v)
    validate_range(v)
  end

  private

  def valid_datetime?(v)
    !!DateTime.parse(v)
  rescue ArgumentError
    false
  end

  def date_format
    config[:format]
  end

  def valid_format?(v)
    return true unless date_format
    !!DateTime.strptime(v, date_format)
  rescue ArgumentError
    false
  end

  def validate_range(v)
    v = v.to_datetime
    return false unless validate_limit(:gt, ">", v)
    return false unless validate_limit(:gteq, ">=", v)
    return false unless validate_limit(:lt, "<", v)
    return false unless validate_limit(:lteq, "<=", v)
    true
  end

  def validate_limit(limit_name, method, v)
    r = valid_limit(limit_name)
    return true if r.blank?
    v.public_send(method, r)
  end

  def valid_limit(name)
    limit = config[name].to_s
    return if limit.blank?
    return limit.to_datetime if valid_datetime?(limit)
    raise Parxer::ValidatorError.new("'#{name}' has not a valid value for given datetime")
  end
end
