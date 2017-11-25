class Parxer::ColumnsValidator < Parxer::BaseValidator
  def validate
    context.attributes.each_with_index do |col, idx|
      return false unless valid_column?(col, idx)
    end

    true
  end

  private

  def valid_column?(col, col_idx)
    !!context.header[col_idx] && context.header[col_idx] == col.name
  end
end
