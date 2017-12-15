class Parxer::NumberFormatter < Parxer::BaseValidator
  def format_value
    v = context.value.to_s
    v = integer? ? v.to_i : v.to_f
    v = v.round(round) if round?
    v
  end

  private

  def integer?
    !!config[:integer]
  end

  def round?
    !integer? && !!config[:round]
  end

  def round
    config[:round].to_s.to_i
  end
end
