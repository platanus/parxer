class Parxer::HeaderOrderValidator < Parxer::BaseValidator
  def validate
    context.attributes.each_with_index do |attribute, idx|
      return false unless valid_header?(attribute, idx)
    end

    true
  end

  private

  def valid_header?(attribute, attribute_idx)
    !!context.header[attribute_idx] && context.header[attribute_idx] == attribute.name
  end
end
