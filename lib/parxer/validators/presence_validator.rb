class Parxer::PresenceValidator < Parxer::BaseValidator
  def validate
    !context.value.to_s.blank?
  end
end
