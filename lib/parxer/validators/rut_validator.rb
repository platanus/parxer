class Parxer::RutValidator < Parxer::BaseValidator
  def validate
    rut = clean_rut
    return true if rut.blank?
    t = rut[0...-1].to_i
    m = 0
    s = 1
    while t.positive?
      s = (s + t % 10 * (9 - m % 6)) % 11
      m += 1
      t /= 10
    end
    v = if s.positive? then (s - 1).to_s else 'K' end
    (v == rut.last.upcase)
  rescue
    false
  end

  private

  def clean_rut
    rut = context.value.to_s
    rut.to_s.upcase!
    rut.delete!(".")
    rut.delete!("-")
    rut
  end
end
