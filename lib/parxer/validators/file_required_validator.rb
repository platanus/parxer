class Parxer::FileRequiredValidator < Parxer::BaseValidator
  def validate
    !context.file.to_s.blank?
  end
end
