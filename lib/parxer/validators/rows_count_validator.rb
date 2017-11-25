class Parxer::RowsCountValidator < Parxer::BaseValidator
  def validate
    context.rows_count <= config[:max].to_i
  end
end
