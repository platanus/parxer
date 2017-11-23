class Parxer::RequiredValidator < Parxer::BaseValidator
  def condition
    !context.value.to_s.blank?
  end
end
