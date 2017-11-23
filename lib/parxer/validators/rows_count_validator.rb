class Parxer::RowsCountValidator < Parxer::BaseValidator
  def condition
    context.rows_count <= config[:max].to_i
  end
end
