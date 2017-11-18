class Parxer::RequiredValidator < Parxer::BaseValidator
  def condition
    !value.to_s.blank?
  end
end
