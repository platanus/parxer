class Parxer::FileRequiredValidator < Parxer::BaseValidator
  def condition
    !context.file.to_s.blank?
  end
end
