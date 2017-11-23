class Parxer::ColumnsValidator < Parxer::BaseValidator
  def condition
    valid = true

    context.attributes.each_with_index do |col, idx|
      if !valid_column?(col, idx)
        valid = false
        break
      end
    end

    valid
  end

  private

  def valid_column?(col, col_idx)
    !!context.header[col_idx] && context.header[col_idx] == col.name
  end
end
