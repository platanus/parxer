class Parxer::RequiredValidator < Parxer::BaseValidator
  def validator
    Proc.new do |_item, value|
      !value.to_s.blank?
    end
  end
end
