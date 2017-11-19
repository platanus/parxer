class Parxer::FileRequiredValidator < Parxer::BaseValidator
  def condition
    !file.to_s.blank?
  end
end
