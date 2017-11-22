class Parxer::RowsCountValidator < Parxer::BaseValidator
  def condition
    rows_count <= config[:max].to_i
  end
end
